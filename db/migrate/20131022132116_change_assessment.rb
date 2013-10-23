class ChangeAssessment < ActiveRecord::Migration
  def change
  	remove_column :assessments, :week
  	add_column :assessments, :week_id, :integer
  end
end
