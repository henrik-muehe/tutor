require 'awesome_print'
require 'prawn'
require 'tempfile'
require 'digest/sha1'

class ExamsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admincheck, except: [:grade]
  before_action :set_exam, only: [:show, :edit, :update, :destroy, :assign_seats, :reset_seats, :print_roomdoor, :print_signatures, :export_seats, :export_grades, :grade]

  # GET /exams
  # GET /exams.json
  def index
    @exams = Exam.all
  end

  # GET /exams/1
  # GET /exams/1.json
  def show
  end

  # GET /exams/new
  def new
    @exam = Exam.new
  end

  # GET /exams/1/edit
  def edit
  end

  def grade
    if params["letter"]
      l = params["letter"]
      return render :json => @exam.participants.select { |p| fix(p["FAMILY_NAME_OF_STUDENT"])[0] == l }
        .map { |p| p.to_hash }
        .map { |p| p.select { |k,v| k == "FAMILY_NAME_OF_STUDENT" || k == "FIRST_NAME_OF_STUDENT" || k == "REGISTRATION_NUMBER" } }
        .map { |p| p.merge({ "HASH" => Digest::SHA1.hexdigest("FUNNYHASH"+p["REGISTRATION_NUMBER"]), "REGISTRATION_NUMBER" => "xxxx" + p["REGISTRATION_NUMBER"][-4,4] }) }
    end
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
    seats = JSON.parse(@exam.seat_assignment)

    Prawn::Document.generate(file, :page_layout => :landscape) do |pdf|
      seats.each_with_index do |roominfo,index|
        pdf.start_new_page if index!=0

        # header
        pdf.formatted_text [{ text: "Unterschriften #{@exam["name"]} - #{roominfo["room"]["name"]}", styles: [:bold], size: 27 }]
        pdf.move_down 15

        # table
        seat2reg = roominfo["mapping"].invert
        reg2student = {}; roominfo["students"].each do |s| reg2student[s["REGISTRATION_NUMBER"].to_i.to_s] = s end

        t = [["<b>MatrNr</b>", "<b>Lastname</b>", "<b>Firstname</b>", "<b>Row</b>", "<b>Seat</b>", "<b>Unterschrift</b>"]]
        t+= roominfo["room"]["seats"].split(/\r?\n/).sort do |a,b|
          seata = extract_seat(a)
          seatb = extract_seat(b)
          seata <=> seatb
        end.map do |seat|
          r = seat2reg[seat].to_i.to_s
          seat = extract_seat(seat)
          if r == "0" then
            [ "<font size='7'><sup>reserve</sup></font>", "", "", seat.first, seat.last, "" ]
          else
            s = reg2student[r]
            [ 
              s["REGISTRATION_NUMBER"],
              s["FAMILY_NAME_OF_STUDENT"],
              s["FIRST_NAME_OF_STUDENT"],
              seat.first,
              seat.last,
              ""
            ]
          end
        end
        pdf.table t, { 
          :header => true,
          :row_colors =>["FFFFFF","eeeeee"], 
          :width => pdf.bounds.width, 
          :cell_style =>{:inline_format => true }, 
          :column_widths => {5 => 300}
        }
      end

      pdf.number_pages "<page>/<total>", {:at => [0, -3],:size => 7}
    end
    send_file file, :type => "application/pdf", :disposition => "attachment"
  end

  def print_roomdoor
    seats = JSON.parse(@exam.seat_assignment)

    Prawn::Document.generate('roomdoor.pdf') do |pdf|
      seats.each_with_index do |roominfo,index|
        pdf.start_new_page if index!=0

        # header
        pdf.formatted_text [
          { text: @exam["name"], styles: [:bold], size: 27 },
          { text: "  -  ", styles: [:bold], size: 27 },
          { text: roominfo["room"]["name"], styles: [:bold], size: 27 },
        ]
        pdf.move_down 15

        # table
        t = [["<b>Lastname</b>", "<b>Firstname</b>", "<b>Seat</b>"]]
        t+= roominfo["students"].map do |s|
          [ s["FAMILY_NAME_OF_STUDENT"],s["FIRST_NAME_OF_STUDENT"],roominfo["mapping"][s["REGISTRATION_NUMBER"].to_i.to_s]]
        end
        pdf.table t, header: true,:row_colors =>["FFFFFF","eeeeee"], :width => pdf.bounds.width, :cell_style =>{:inline_format => true }
      end

      pdf.number_pages "<page>/<total>", {:at => [0, -3],:size => 7}
      send_data pdf.render, :filename => "roomdoor.pdf", :type => "application/pdf"
    end
  end

  def fix(s)
    ActiveSupport::Inflector.transliterate(s)
  end

  def assign_seats
    return redirect_to @exam, notice: "You must reset the seat assignment before calling assign again" if @exam.seat_assignment
    parts = @exam.participants

    # Determine available and required seats
    rooms = @exam.rooms
    roomCounts = rooms.map { |r| r.seat_count }
    total = roomCounts.inject(0) { |sum, r| sum + r }
    leftover = total - parts.size
    return redirect_to @exam, notice: "You have insufficient rooms, you need #{-leftover} more seats." if leftover < 0

    # Convervatively even out on rooms
    roomCounts.map! { |r| (r * (1-(leftover/total.to_f))).ceil }

    # Reduce largest room until exact count is reached
    while roomCounts.reduce(:+) > parts.size
      roomCounts[roomCounts.each_with_index.max[1]] -= 1
    end

    # Split students
    last = 0
    roomStudents = rooms.map { [] }
    currentRoom=0
    parts.sort {|a,b| [fix(a["FAMILY_NAME_OF_STUDENT"]), fix(a["FIRST_NAME_OF_STUDENT"])] <=> [fix(b["FAMILY_NAME_OF_STUDENT"]), fix(b["FIRST_NAME_OF_STUDENT"])] }.each do |p|
      roomStudents[currentRoom] << p.to_hash
      currentRoom+=1 if (roomStudents[currentRoom].length >= roomCounts[currentRoom])
    end

    # Generate data to save
    @exam.seat_assignment = (rooms.each_with_index.map do |r,index|
      # Map seats
      rs = r.seats.split(/\r?\n/).shuffle
      mapping = {}
      roomStudents[index].each_with_index { |s,i| p s; mapping[s["REGISTRATION_NUMBER"].to_i] = rs[i.to_i] }
      {
        room: r, 
        seats_used: roomCounts[index],
        students: roomStudents[index],
        mapping: mapping
      }
    end).to_json
    @exam.save

    redirect_to @exam
  end

  def reset_seats
    @exam.seat_assignment = nil
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
      params.require(:exam).permit(:name, :start, :original_import, { :room_ids => [] }, :exam_tasks_attributes => [:id, :number, :name, :max_points, :_destroy] )
    end
end
