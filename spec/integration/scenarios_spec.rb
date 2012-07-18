require 'spec_helper'

feature 'A new scenario' do

  # --------------------------------------------------------------------------

  let!(:question_set) { create :full_question_set, name: 'gasmixer' }

  def global_json
    source = page.find('script#global_json').text
    source = source.gsub("\nvar globals = ", '')

    JSON.parse(source)
  end

  # --------------------------------------------------------------------------

  scenario 'Shows the question set form' do
    visit 'http://gasmixer.example.com/mixes/new'

    page.status_code.should eql(200)

    # Two questions?
    page.should have_css(".question_tab", count: 2)

    # Four answers (2 answers x 2 questions)
    page.should have_css(".answer input", count: 4)

    # Make sure the correct dashboard steps were used.
    steps = global_json['chart']['dashboard_steps']

    steps.should have(question_set.dashboard_items.count).elements

    0.upto(3) do |number|
      item = question_set.dashboard_items[number]
      steps[item.gquery].should eql(item.steps.split(',').map(&:to_f))
    end
  end

  # --------------------------------------------------------------------------

  scenario 'Filling out questions', :js do
    visit 'http://gasmixer.mixer.dev:54163/mixes/new'

    # Select a first answer.

    find('.answers .answer:first label').click
    wait_for_xhr

    click_on 'Next question >>'

    # Select a second answer.

    find('.answers .answer:first label').click
    wait_for_xhr

    click_on 'Next question >>'

    # Save scenario.

    fill_in 'Name',              with: 'Benjamin Chang'
    fill_in 'E-mail',            with: 'chang@example.com'
    fill_in 'Age',               with: '36'
    fill_in 'Name for this mix', with: 'Chang The World'

    check 'I agree with the terms and conditions'

    click_on 'Save my mix'

    # --

    page.should have_css('h2', text: "Benjamin Chang's mix (36 years old)")

    Scenario.last.question_set_id.should eql(question_set.id)
  end

  # --------------------------------------------------------------------------

  scenario 'Does not show questions from other question sets' do
    other_set = create :full_question_set

    # Make dashboard gqueries "clash" to ensure that the correct step values
    # are used.

    other_set.dashboard_items[0].update_attributes!(
      gquery: question_set.dashboard_items[0].gquery)

    other_set.dashboard_items[1].update_attributes!(
      gquery: question_set.dashboard_items[1].gquery)

    #--

    visit 'http://gasmixer.example.com/mixes/new'

    # Correct number of everything?
    page.should have_css('.question_tab', count: 2)
    page.should have_css('.answer input', count: 4)

    # Make sure the correct dashboard steps were used.
    steps = global_json['chart']['dashboard_steps']

    steps.should have(4).elements

    0.upto(3) do |number|
      item = question_set.dashboard_items[number]
      steps[item.gquery].should eql(item.steps.split(',').map(&:to_f))
    end
  end

  # --------------------------------------------------------------------------

  scenario 'Viewing a saved scenario' do
    saved = create :scenario, question_set: question_set, output_5: 5

    other_set = create :full_question_set

    # Make dashboard gqueries "clash" to ensure that the correct step values
    # are used.

    other_set.dashboard_items[0].update_attributes!(
      steps:  '5,10,15',
      gquery: 'mixer_reduction_of_co2_emissions_versus_1990')

    # And give the correct dashboard item a different set of steps.

    question_set.dashboard_items[0].update_attributes!(
      steps:  '2,4,6',
      gquery: 'mixer_reduction_of_co2_emissions_versus_1990')

    # --

    visit "http://gasmixer.example.com/mixes/#{ saved.id }"

    page.status_code.should eql(200)

    # Correct dashboard steps?
    page.should     have_css('.mixer_reduction_of_co2_emissions_versus_1990_step_2')
    page.should_not have_css('.mixer_reduction_of_co2_emissions_versus_1990_step_1')
  end

  # --------------------------------------------------------------------------

  scenario 'Viewing a scenario from an other question set' do
    other = create :scenario, question_set: create(:question_set, name: 'o')

    visit "http://gasmixer.example.com/mixes/#{ other.id }"

    # We should be back on the root page.
    page.should_not have_css('#user_chart')
    page.should     have_css('#intro')
  end

  # --------------------------------------------------------------------------

  scenario 'QuestionSet with an unusual end year and area code', :js do
    question_set.update_attributes!(end_year: 2041)

    partition = Partition.named(question_set.name)
    settings  = partition.api_settings.dup

    settings[:area_code] = 'de'

    partition.stubs(:api_settings).returns(settings)
    Partition.stubs(:named).returns(partition)

    # --

    visit 'http://gasmixer.mixer.dev:54163/mixes/new'

    wait_for_xhr

    page.should have_css('#user_chart header', text: '2041')

    page.evaluate_script('window.app.end_year').should eql(2041)
    page.evaluate_script('window.app.area_code').should eql('de')
  end

  # --------------------------------------------------------------------------
end
