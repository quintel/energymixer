require 'spec_helper'

describe "inputs/show.html.haml" do
  before(:each) do
    @input = assign(:input, stub_model(Input,
      :key => "Key",
      :value => "9.99",
      :answr_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Key/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
