class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.integer :student_id
      t.integer :user_id
      t.integer :value
      t.string :remark
      t.datetime :week

      t.timestamps
    end
  end
end
