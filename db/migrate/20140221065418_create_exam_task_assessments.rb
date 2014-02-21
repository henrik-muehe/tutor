class CreateExamTaskAssessments < ActiveRecord::Migration
	def change
		create_table :exam_task_assessments do |t|
			t.integer :student_id
			t.integer :exam_task_id
			t.decimal :points, :precision => 4, :scale => 2
			t.timestamps
		end
		add_index :exam_task_assessments, :student_id
		add_index :exam_task_assessments, :exam_task_id
	end
end
