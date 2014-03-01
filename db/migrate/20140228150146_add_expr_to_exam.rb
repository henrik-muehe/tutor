class AddExprToExam < ActiveRecord::Migration
  def change
  	add_column :exams, :expr, :text
  end
end
