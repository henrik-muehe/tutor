class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.integer :matrnr

      t.timestamps
    end
  end
end
