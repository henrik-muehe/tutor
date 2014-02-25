class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :chat_messages, :room
  end
end
