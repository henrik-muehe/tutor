class AddStartWeek < ActiveRecord::Migration
  def change
  	add_column :courses, :startweek, :datetime
  end
end
