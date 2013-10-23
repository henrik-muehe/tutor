class AddGroupsStudents < ActiveRecord::Migration
  def change
  	create_table :groups_students do |t|
  		t.belongs_to :group
  		t.belongs_to :student
  	end
  end
end
