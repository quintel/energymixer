require 'spec_helper'

describe Scenario do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
end
