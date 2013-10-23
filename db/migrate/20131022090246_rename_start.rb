class RenameStart < ActiveRecord::Migration
  def change
  	rename_column :groups,:start,:starttime
  end
end
