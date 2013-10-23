class AddWeekAssoc < ActiveRecord::Migration
  def change
  	add_column :weeks, :course_id, :integer
  end
end
