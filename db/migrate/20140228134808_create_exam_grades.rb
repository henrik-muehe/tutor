class CreateExamGrades < ActiveRecord::Migration
  def change
    create_table :exam_grades do |t|
      t.decimal :grade, :precision => 2, :scale => 1
      t.text :remark
      t.references :exam, index: true
      t.references :student, index: true
      t.references :exam_assessment, index: true

      t.timestamps
    end
  end
end
