class AddEnglishLanguage < ActiveRecord::Migration
  def self.up
    add_column :answers, :text_en, :text
    add_column :answers, :description_en, :text
    add_column :popups, :title_en, :string
    add_column :popups, :body_en, :text
    add_column :popups, :video_en, :string
    add_column :questions, :text_en, :string
    add_column :questions, :description_en, :text
  end

  def self.down
    remove_column :answers, :text_en
    remove_column :answers, :description_en
    remove_column :popups, :title_en
    remove_column :popups, :body_en
    remove_column :popups, :video_en
    remove_column :questions, :text_en
    remove_column :questions, :description_en
  end
end
