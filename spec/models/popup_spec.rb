require 'spec_helper'

describe Popup do
  let!(:popup) { Factory :popup }
  it { should validate_presence_of :code }
  it { should validate_uniqueness_of :code }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end