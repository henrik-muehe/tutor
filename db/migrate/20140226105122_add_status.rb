class AddStatus < ActiveRecord::Migration
  def change
  	add_column :exam_assessments, :status, :string
  end
end
