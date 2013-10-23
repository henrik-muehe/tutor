class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.datetime :start
      t.integer :user_id
      t.integer :course_id

      t.timestamps
    end
  end
end
