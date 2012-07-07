require 'spec_helper'

describe Scenario do
  it { should belong_to :question_set }
  it { should validate_presence_of :name }
  it { should validate_presence_of :question_set_id }
end
