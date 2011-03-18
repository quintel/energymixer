require 'spec_helper'

describe UserScenarioAnswer do
  it { should belong_to :answer }
  it { should belong_to :user_scenario }
  it { should belong_to :question }
end
