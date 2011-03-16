require 'spec_helper'

describe UserScenario do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
end
