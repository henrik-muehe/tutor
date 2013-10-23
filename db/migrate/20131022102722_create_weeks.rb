class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.datetime :start

      t.timestamps
    end
  end
end
