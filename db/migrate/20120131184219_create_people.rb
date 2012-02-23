class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :Last
      t.string :First
      t.string :Pin
      t.string :Longitude
      t.string :Latitude
      t.string :Address
      t.string :City
      t.string :Region
      t.string :State
      t.string :Zip
      t.string :Country

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
