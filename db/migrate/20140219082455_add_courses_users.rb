class AddCoursesUsers < ActiveRecord::Migration
  def change
  	create_table :courses_users do |t|
  	  t.integer :course_id
  	  t.integer :user_id
      t.timestamps
    end
    add_index :courses_users, :course_id
    add_index :courses_users, :user_id
  end
end
