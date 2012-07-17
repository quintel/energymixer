require 'spec_helper'

feature 'Creating a scenario' do

  # --------------------------------------------------------------------------

  let!(:question_set) { create :full_question_set, name: 'gasmixer' }

  # --------------------------------------------------------------------------

  scenario 'Given valid attributes' do
    sign_in create(:user)

    click_link 'Mixes'
    click_link 'New User Scenario'

    fill_in 'Name', with: 'My First Scenario'

    0.upto(12) { |number| fill_in "Output #{number}", with: number.to_s }

    click_button 'Create Scenario'

    page.should have_css('#notice', text: 'Scenario was successfully created')

    Scenario.last.question_set_id.should eql(question_set.id)
  end

  # --------------------------------------------------------------------------

end
