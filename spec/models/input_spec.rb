require 'spec_helper'

describe Input do
  it { should validate_presence_of :key }
  it { should validate_presence_of :value }
end

