class AddHamlViewToAnalysis < ActiveRecord::Migration
  def change
  	add_column :analyses, :view, :text
  end
end
