class AddGroupToAssessment < ActiveRecord::Migration
  def change
  	add_column :assessments, :group_id, :integer
  end
end
