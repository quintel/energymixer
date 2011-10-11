class AddTranslationColumns < ActiveRecord::Migration
  def self.up
    rename_column :answers,   :answer, :text_nl
    rename_column :answers,   :description, :description_nl
    rename_column :popups,    :title, :title_nl
    rename_column :popups,    :body, :body_nl
    rename_column :questions, :question, :text_nl
    rename_column :questions, :information, :description_nl
    
    add_column :answers, :text_de, :text
    add_column :answers, :description_de, :text    
    add_column :popups, :title_de, :string
    add_column :popups, :body_de, :text
    add_column :questions, :text_de, :string
    add_column :questions, :description_de, :text
  end

  def self.down
    rename_column :answers,   :text_nl, :answer
    rename_column :answers,   :description_nl, :description
    rename_column :popups,    :title_nl, :title
    rename_column :popups,    :body_nl, :body
    rename_column :questions, :text_nl, :question
    rename_column :questions, :info_nl, :information

    remove_column :answers, :text_de
    remove_column :answers, :description_de
    remove_column :popups, :title_de
    remove_column :popups, :body_de
    remove_column :questions, :text_de
    remove_column :questions, :description_de
  end
end
