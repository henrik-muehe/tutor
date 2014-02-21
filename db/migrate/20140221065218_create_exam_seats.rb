class CreateExamSeats < ActiveRecord::Migration
	def change
		create_table :exam_seats do |t|
			t.integer :exam_id
			t.integer :student_id
			t.integer :room_id
			t.string :seat_string
			t.timestamps
		end
		add_index :exam_seats, :exam_id
		add_index :exam_seats, :student_id
		add_index :exam_seats, :room_id
	end
end
