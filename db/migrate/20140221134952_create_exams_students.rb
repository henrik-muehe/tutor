class CreateExamsStudents < ActiveRecord::Migration
  def change
    create_table :exams_students do |t|
      t.integer :exam_id
      t.integer :student_id
    end
	add_index :exams_students, :exam_id
	add_index :exams_students, :student_id
  end
end
