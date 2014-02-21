class CreateExamAssessments < ActiveRecord::Migration
  def change
    create_table :exam_assessments do |t|
      t.integer :exam_id
      t.integer :student_id
      t.timestamps
    end
	add_index :exam_assessments, :exam_id
	add_index :exam_assessments, :student_id
	remove_column :exam_task_assessments, :exam_id
	remove_column :exam_task_assessments, :student_id
	add_column :exam_task_assessments, :exam_assessment_id, :integer
	add_index :exam_task_assessments, :exam_assessment_id
  end
end
