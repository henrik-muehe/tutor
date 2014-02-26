require 'awesome_print'
require 'prawn'
require 'tempfile'
require 'digest/sha1'

class ExamsController < ApplicationController
  before_filter :authenticate_user!, except: [:grade, :grade_save]
  before_filter :admincheck, except: [:grade, :grade_save]
  before_filter :magiccheck, only: [:grade, :grade_save]
  before_action :set_exam, only: [:show, :edit, :update, :destroy, :assign_seats, :reset_seats, :print_roomdoor, :print_signatures, :export_seats, :export_grades, :grade, :grade_save]

  def magiccheck
    render_403 unless Exam.where(id: params[:id], magictoken: params[:magictoken]).present?
  end

  # GET /exams
  # GET /exams.json
  def index
    @exams = @course.exams
    @other_exams = Exam.where('id not in (?)', @exams.map{ |e| e.id }.to_a + [ -1 ])
  end

  # GET /exams/1
  # GET /exams/1.json
  def show
  end

  # GET /exams/new
  def new
    @exam = Exam.new({course: @course})
  end

  # GET /exams/1/edit
  def edit
  end

  def grade
    if params["letter"]
      l = params["letter"]
      return render json: @exam.students.to_a.select { |student| fix(student.lastname)[0] == l }
        .map { |student| student.serializable_hash.select { |k,v| ["matrnr","lastname","firstname","id"].include?(k) } }
        .map { |student| 
          ea = ExamAssessment.where(student_id: student["id"], exam: @exam).first
          student.merge({
            matrnr: "xxxx" + student["matrnr"].to_s[-4,4], 
            assessment_string: ea.present? ? ea.assessment_string : ""
          }) 
        }
    end

    if params["check"]
      a = ExamAssessment.new({ exam: @exam, assessment_string: params["check"] })
      a.valid?
      render :json => a.errors[:exam_task_assessments].to_a
    end
  end

  def grade_save
    ActiveRecord::Base.transaction do
      params["points"].each do |id,str|
        ExamAssessment.where(:exam_id => @exam.id, :student_id => id).delete
        ExamAssessment.create({
          exam: @exam,
          student: Student.find(id),
          assessment_string: str
        })
      end
    end
    redirect_to :action => :grade, :magictoken => params[:magictoken]
  end

  def extract_seat(s)
    seat = s.gsub(/^.*Reihe /, "").gsub("Platz ",":").split(":")
    seat.map do |v| 
      if v.strip.match(/^[0-9]+$/)
        v.strip.to_i
      else
        v.strip
      end
    end
  end

  def export_seats
    file="/tmp/export-seats-#{Time.now.to_i}.csv"
    @exam.export_seats(file)
    send_file file, :type => "application/force-download", :disposition => "attachment"
  end

  def export_grades
    raise "implement me"
    file="/tmp/export-grades-#{Time.now.to_i}.csv"
    @exam.export(file)
    send_file file, :type => "text/csv", :disposition => "attachment"
  end

  def print_signatures
    file="/tmp/signatures-#{Time.now.to_i}.pdf"
    Prawn::Document.generate(file, :page_layout => :landscape) do |pdf|
      @exam.rooms.order(:name).each_with_index do |room,index|
        pdf.start_new_page if index!=0

        # header
        pdf.formatted_text [{ text: "Unterschriften #{@exam.name} - #{room.name}", styles: [:bold], size: 27 }]
        pdf.move_down 15

        t = [["<b>MatrNr</b>", "<b>Lastname</b>", "<b>Firstname</b>", "<b>Row</b>", "<b>Seat</b>", "<b>Unterschrift</b>"]]
        t+= @exam.exam_seats.includes(:student).where(room_id: room).to_a.sort_by { |a| 
          a.split 
        }.map do |seat|
          if not seat.student.present?
            [ "<font size='7'><sup>reserve</sup></font>", "", "", seat.row, seat.seat, "" ]
          else
            [ 
              seat.student.matrnr,
              seat.student.lastname,
              seat.student.firstname,
              seat.row,
              seat.seat,
              ""
            ]
          end
        end

        pdf.table t, { 
          :header => true,
          :row_colors =>["FFFFFF","eeeeee"], 
          :width => pdf.bounds.width, 
          :cell_style =>{:inline_format => true }, 
          :column_widths => {5 => 250}
        }
      end

      pdf.number_pages "<page>/<total>", {:at => [0, -3],:size => 7}
    end
    send_file file, :type => "application/pdf", :disposition => "attachment"
  end

  def print_roomdoor
    file="/tmp/roomdoor-#{Time.now.to_i}.pdf"
    Prawn::Document.generate(file) do |pdf|
      @exam.rooms.order(:name).each_with_index do |room,index|
        pdf.start_new_page if index!=0

        # header
        pdf.formatted_text [{ text: "Aushang #{@exam.name} - #{room.name}", styles: [:bold], size: 27 }]
        pdf.move_down 15

        # table
        t = [["<b>Lastname</b>", "<b>Firstname</b>", "<b>Seat</b>"]]
        t+= @exam.exam_seats.includes(:student).where(["room_id = ? and student_id is not null",room.id]).sort { |a,b| 
          [fix(a.student.lastname),fix(a.student.firstname)]<=>[fix(b.student.lastname),fix(b.student.firstname)]
        }.map do |seat|
          [ seat.student.lastname,seat.student.firstname,seat.seat_string]
        end
        pdf.table t, header: true,:row_colors =>["FFFFFF","eeeeee"], :width => pdf.bounds.width, :cell_style =>{:inline_format => true }
      end

      pdf.number_pages "<page>/<total>", {:at => [0, -3],:size => 7}
    end
    send_file file, :type => "application/pdf", :disposition => "attachment"
  end

  def fix(s)
    ActiveSupport::Inflector.transliterate(s)
  end

  def assign_seats
    return redirect_to @exam, notice: "You must reset the seat assignment before calling assign again" if @exam.exam_seats.length > 0

    ActiveRecord::Base.transaction do
      # Determine available and required seats
      rooms = @exam.rooms.order(:name)
      roomCounts = rooms.map { |r| r.seat_count }
      total = roomCounts.inject(0) { |sum, r| sum + r }
      leftover = total - @exam.students.size
      return redirect_to @exam, notice: "You have insufficient rooms, you need #{-leftover} more seats." if leftover < 0

      # Convervatively even out on rooms
      roomCounts.map! { |r| (r * (1-(leftover/total.to_f))).ceil }

      # Reduce largest room until exact count is reached
      while roomCounts.reduce(:+) > @exam.students.size
        roomCounts[roomCounts.each_with_index.max[1]] -= 1
      end

      # Split students
      last = 0
      roomStudents = rooms.map { [] }
      currentRoom=0
      students = @exam.students.sort { |a,b| [fix(a.lastname),fix(a.firstname)]<=>[fix(b.lastname),fix(b.firstname)] }
      students.each do |s|
        roomStudents[currentRoom] << s
        currentRoom+=1 if (roomStudents[currentRoom].length >= roomCounts[currentRoom])
      end

      # Map seats
      rooms.each_with_index.map do |room,index|
        random_seats = room.seats.split(/\r?\n/).shuffle
        roomStudents[index].each_with_index do |student,i| 
          @exam.exam_seats << ExamSeat.create({ student: student, room: room, seat_string: random_seats[i] })
        end
        for i in (roomStudents[index].length..random_seats.length-1)
          @exam.exam_seats << ExamSeat.create({ room: room, seat_string: random_seats[i] })
        end
      end
      @exam.save
    end

    redirect_to @exam
  end

  def reset_seats
    @exam.exam_seats.delete_all
    @exam.save
    redirect_to @exam, notice: "Seat assignment successfully reset."
  end

  # POST /exams
  # POST /exams.json
  def create
    @exam = Exam.new(exam_params)

    respond_to do |format|
      if @exam.save
        format.html { redirect_to @exam, notice: 'Exam was successfully created.' }
        format.json { render action: 'show', status: :created, location: @exam }
      else
        format.html { render action: 'new' }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exams/1
  # PATCH/PUT /exams/1.json
  def update
    respond_to do |format|
      if @exam.update(exam_params)
        format.html { redirect_to @exam, notice: 'Exam was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exams/1
  # DELETE /exams/1.json
  def destroy
    @exam.destroy
    respond_to do |format|
      format.html { redirect_to exams_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      params.require(:exam).permit(:name, :start, :course_id, :original_import, :magictoken, { :room_ids => [] }, :exam_tasks_attributes => [:id, :number, :name, :max_points, :_destroy] )
    end
end
