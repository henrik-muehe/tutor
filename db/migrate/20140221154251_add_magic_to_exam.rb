class AddMagicToExam < ActiveRecord::Migration
  def change
  	add_column :exams, :magictoken, :string
  end
end
