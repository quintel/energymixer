class AddPresetIdToQuestionSet < ActiveRecord::Migration
  def change
    add_column :question_sets, :preset_id, :integer, null: true
  end
end
