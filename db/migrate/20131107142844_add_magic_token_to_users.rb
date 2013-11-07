class AddMagicTokenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :magictoken, :string
  end
end
