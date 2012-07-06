require 'spec_helper'

describe DashboardItem do
  it { should validate_presence_of :gquery }
  it { should validate_presence_of :label }
  it { should validate_presence_of :question_set_id }
  it { should belong_to(:question_set) }
end
