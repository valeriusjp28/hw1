class AddIpaddressToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :ipaddress, :string
  end

  def self.down
    remove_column :people, :ipaddress
  end
end
