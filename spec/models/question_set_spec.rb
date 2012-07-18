require 'spec_helper'

describe QuestionSet do
  it { should validate_presence_of :name }
  it { should validate_numericality_of(:end_year).only_integer }

  it do
    create :question_set
    should validate_uniqueness_of :name
  end
end
