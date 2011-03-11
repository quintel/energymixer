require 'spec_helper'

describe InputElement do

  subject { Factory(:input_element) }

  it { should have_db_index(:key).unique(true) }

  it { should validate_presence_of :key }
  it { should validate_uniqueness_of :key }
  it { should ensure_length_of(:key).is_at_most(255) }

end
