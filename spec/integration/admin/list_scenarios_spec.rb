require 'spec_helper'

feature 'Listing scenarios' do

  # --------------------------------------------------------------------------

  let!(:question_set) { create :full_question_set, name: 'gasmixer' }

  # --------------------------------------------------------------------------

  scenario 'Viewing the list' do
    create :scenario, question_set: question_set, name: 'First Scenario'
    create :scenario, question_set: question_set, name: 'Second Scenario'

    sign_in create(:user)
    click_link 'Mixes'

    page.should have_css('a', text: 'First Scenario')
    page.should have_css('a', text: 'Second Scenario')
  end

  # --------------------------------------------------------------------------

  scenario 'Not showing scenarios from other sets' do
    create :scenario, question_set: question_set, name: 'Yes Scenario'
    create :scenario,                             name: 'No Scenario'

    sign_in create(:user)
    click_link 'Mixes'

    page.should     have_css('a', text: 'Yes Scenario')
    page.should_not have_css('a', text: 'No Scenario')
  end

  # --------------------------------------------------------------------------

end
