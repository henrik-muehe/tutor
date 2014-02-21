class AddSeatsToExam < ActiveRecord::Migration
  def change
  	add_column :exams, :seat_assignment, :text
  end
end
