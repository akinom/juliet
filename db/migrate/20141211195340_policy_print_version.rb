class PolicyPrintVersion < ActiveRecord::Migration
  def up
    add_column :policies, :print_version, :string
  end

  def down
    remove_column :policies, :print_version
  end
end
