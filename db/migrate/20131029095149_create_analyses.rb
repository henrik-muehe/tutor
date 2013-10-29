class CreateAnalyses < ActiveRecord::Migration
  def change
    create_table :analyses do |t|
      t.string :name
      t.text :query
      t.boolean :admin

      t.timestamps
    end
  end
end
