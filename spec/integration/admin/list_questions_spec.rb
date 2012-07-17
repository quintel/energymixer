require 'spec_helper'

feature 'Listing questions' do

  # --------------------------------------------------------------------------

  let!(:question_set) { create :full_question_set, name: 'gasmixer' }

  # --------------------------------------------------------------------------

  scenario 'Viewing the list' do
    question_set.questions[0].update_attributes! text_en: 'First Question'
    question_set.questions[1].update_attributes! text_en: 'Second Question'

    sign_in create(:user)
    click_link 'Questions'

    page.should have_css('a', text: 'First Question')
    page.should have_css('a', text: 'Second Question')
  end

  # --------------------------------------------------------------------------

  scenario 'Not showing questions from other sets' do
    create :question, question_set: question_set, text_en: 'Yes Question'
    create :question,                             text_en: 'No Question'

    sign_in create(:user)
    click_link 'Questions'

    page.should     have_css('a', text: 'Yes Question')
    page.should_not have_css('a', text: 'No Question')
  end

  # --------------------------------------------------------------------------

end
