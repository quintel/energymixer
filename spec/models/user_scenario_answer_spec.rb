require 'spec_helper'

describe ScenarioAnswer do
  it { should belong_to :answer }
  it { should belong_to :scenario }
  it { should belong_to :question }
end
