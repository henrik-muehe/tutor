class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.string :room
      t.string :type
      t.text :message

      t.timestamps
    end
  end
end
