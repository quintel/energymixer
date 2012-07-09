require 'spec_helper'

feature 'A new scenarios' do

  # --------------------------------------------------------------------------

  let!(:question_set) { create :full_question_set }

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

    steps.should have(2).elements

    steps[ question_set.dashboard_items[0].gquery ].should \
      eql( question_set.dashboard_items[0].steps.split(',').map(&:to_f) )

    steps[ question_set.dashboard_items[1].gquery ].should \
      eql( question_set.dashboard_items[1].steps.split(',').map(&:to_f) )
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

    steps.should have(2).elements

    steps[ question_set.dashboard_items[0].gquery ].should \
      eql( question_set.dashboard_items[0].steps.split(',').map(&:to_f) )

    steps[ question_set.dashboard_items[1].gquery ].should \
      eql( question_set.dashboard_items[1].steps.split(',').map(&:to_f) )
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

    # binding.pry
    page.status_code.should eql(200)

    # Correct dashboard steps?
    page.should     have_css('.mixer_reduction_of_co2_emissions_versus_1990_step_2')
    page.should_not have_css('.mixer_reduction_of_co2_emissions_versus_1990_step_1')
  end

  # --------------------------------------------------------------------------

end
