class AddPopupVideo < ActiveRecord::Migration
  def self.up
    add_column :popups, :video_nl, :string
    add_column :popups, :video_de, :string
  end

  def self.down
    remove_column :popups, :video_nl
    remove_column :popups, :video_de
  end
end
