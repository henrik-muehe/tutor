class AddToken < ActiveRecord::Migration
  def change
  	add_column :students, :token, :string
    add_index :students, :token, :unique => true
  end
end
