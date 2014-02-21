class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.string :name
      t.datetime :start
      t.text :original_import

      t.timestamps
    end
  end
end
