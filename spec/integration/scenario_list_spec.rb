require 'spec_helper'

feature 'The scenarios list' do

  # --------------------------------------------------------------------------

  let!(:question_set) { create :full_question_set, name: 'gasmixer' }

  # --------------------------------------------------------------------------

  scenario 'Viewing the list' do
    other_set      = create :question_set, name: 'other'

    scenario_one   = create :scenario, question_set: question_set, name: 'AAA'
    scenario_two   = create :scenario, question_set: question_set, name: 'BBB'
    other_scenario = create :scenario, question_set: other_set,    name: 'CCC'

    visit 'http://gasmixer.example.com/mixes'

    page.should     have_css('.name', text: 'AAA')
    page.should     have_css('.name', text: 'BBB')
    page.should_not have_css('.name', text: 'CCC')
  end

  # --------------------------------------------------------------------------

  scenario 'Searching for scenarios', :js do
    other_set      = create :question_set, name: 'other'

    scenario_one   = create :scenario, question_set: question_set, name: 'AAA'
    scenario_two   = create :scenario, question_set: question_set, name: 'BBB'
    other_scenario = create :scenario, question_set: other_set,    name: 'CCC'

    visit 'http://gasmixer.mixer.dev:54163/mixes'

    # Scenario which exists.

    fill_in 'q', with: "AAA"
    page.evaluate_script(%{document.forms[0].submit(); []})

    page.should     have_css('.name', text: 'AAA')
    page.should_not have_css('.name', text: 'BBB')
    page.should_not have_css('.name', text: 'CCC')

    # Another scenario which exits.

    fill_in 'q', with: 'BBB'
    page.evaluate_script(%{document.forms[0].submit(); []})

    page.should_not have_css('.name', text: 'AAA')
    page.should     have_css('.name', text: 'BBB')
    page.should_not have_css('.name', text: 'CCC')

    # Scenario belonging to another partition.

    fill_in 'q', with: 'CCC'
    page.evaluate_script(%{document.forms[0].submit(); []})

    page.should_not have_css('.name', text: 'AAA')
    page.should_not have_css('.name', text: 'BBB')
    page.should_not have_css('.name', text: 'CCC')
  end

  # --------------------------------------------------------------------------

end
