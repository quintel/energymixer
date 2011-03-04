require 'spec_helper'

describe "inputs/index.html.haml" do
  before(:each) do
    assign(:inputs, [
      stub_model(Input,
        :key => "Key",
        :value => "9.99",
        :answr_id => 1
      ),
      stub_model(Input,
        :key => "Key",
        :value => "9.99",
        :answr_id => 1
      )
    ])
  end

  it "renders a list of inputs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
