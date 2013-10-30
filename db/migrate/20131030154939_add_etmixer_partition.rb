class AddEtmixerPartition < ActiveRecord::Migration
  def up
    QuestionSet.create(name: 'etmixer', end_year: 2050)
  end

  def down
    QuestionSet.where(name: 'etmixer').first.destroy
  end
end
