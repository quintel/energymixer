require 'spec_helper'

feature 'Creating a new question' do

  # --------------------------------------------------------------------------

  let!(:question_set) { create :full_question_set, name: 'gasmixer' }

  # --------------------------------------------------------------------------

  scenario 'Given valid attributes' do
    sign_in create(:user)

    click_link 'Questions'
    click_link 'New Question'

    fill_in 'Text nl', with: 'NL Text'
    fill_in 'Text en', with: 'EN Text'

    click_button 'Create Question'

    page.should have_css('#notice', text: 'Question was successfully created')

    Question.last.question_set_id.should eql(question_set.id)
  end

  # --------------------------------------------------------------------------

end
