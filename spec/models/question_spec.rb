require 'spec_helper'

describe Question do
  it { should validate_presence_of :question }
  it { should have_many :answers }
end
