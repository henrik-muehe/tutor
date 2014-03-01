class AddExamToAnalysis < ActiveRecord::Migration
  def change
  	add_column :analyses, :exam, :boolean, :default => false
  end
end
