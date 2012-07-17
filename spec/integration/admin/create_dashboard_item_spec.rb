require 'spec_helper'

feature 'Creating a new dashboard item' do

  # --------------------------------------------------------------------------

  let!(:question_set) { create :full_question_set, name: 'gasmixer' }

  # --------------------------------------------------------------------------

  scenario 'Given valid attributes' do
    sign_in create(:user)

    click_link 'Dashboard Items'
    click_link 'New Dashboard Item'

    fill_in 'Label',  with: 'My Dashboard Item'
    fill_in 'Gquery', with: 'something'

    click_button 'Create Dashboard item'

    page.should have_css('#notice',
      text: 'Dashboard Item was successfully created')

    DashboardItem.last.question_set_id.should eql(question_set.id)
  end

  # --------------------------------------------------------------------------

end
