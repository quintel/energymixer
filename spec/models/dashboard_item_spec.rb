require 'spec_helper'

describe DashboardItem do
  it { should validate_presence_of :gquery }
  it { should validate_presence_of :label }
  it { should validate_presence_of :steps }
end
