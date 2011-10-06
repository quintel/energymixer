class AddGeolocationFields < ActiveRecord::Migration
  def self.up
    add_column :scenarios, :longitude, :float
    add_column :scenarios, :latitude, :float
  end

  def self.down
    remove_column :scenarios, :longitude
    remove_column :scenarios, :latitude
  end
end
