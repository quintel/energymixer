class FixNilValuesOnFeatured < ActiveRecord::Migration
  def self.up
    change_column :scenarios, :featured, :boolean, :default => false, :null => false
  end

  def self.down
    change_column :scenarios, :featured, :boolean, :default => nil, :null => true
  end
end
