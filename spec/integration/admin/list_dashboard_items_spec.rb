require 'spec_helper'

feature 'Listing dashboard items' do

  # --------------------------------------------------------------------------

  let!(:question_set) { create :full_question_set, name: 'gasmixer' }

  # --------------------------------------------------------------------------

  scenario 'Viewing the list' do
    question_set.dashboard_items[0].update_attributes! label: 'First Dash'
    question_set.dashboard_items[1].update_attributes! label: 'Second Dash'

    sign_in create(:user)
    click_link 'Dashboard Items'

    page.should have_css('a', text: 'First Dash')
    page.should have_css('a', text: 'Second Dash')
  end

  # --------------------------------------------------------------------------

  scenario 'Not showing items from other sets' do
    question_set.dashboard_items[0].update_attributes! label: 'First Dash'
    create :dashboard_item,                            label: 'No Dash'

    sign_in create(:user)
    click_link 'Dashboard Items'

    page.should     have_css('a', text: 'First Dash')
    page.should_not have_css('a', text: 'No Dash')
  end

  # --------------------------------------------------------------------------

end
