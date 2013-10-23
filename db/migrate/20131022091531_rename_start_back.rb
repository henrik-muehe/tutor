class RenameStartBack < ActiveRecord::Migration
  def change
  	rename_column :groups,:starttime,:start
  end
end
