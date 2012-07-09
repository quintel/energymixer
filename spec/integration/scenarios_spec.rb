require 'spec_helper'

feature 'A new scenarios' do

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

    page.should     have_css(".question_tab", count: 2)
    page.should     have_css(".question_tab[data-question_id='1']")
    page.should     have_css(".question_tab[data-question_id='2']")
    page.should_not have_css(".question_tab[data-question_id='3']")

    # Four answers (2 answers x 2 questions)

    aids = question_set.questions.map { |q| q.answers.map(&:id) }.flatten

    page.should have_css(".answer input", count: 4)
    page.should have_css(".answer input#answer_#{aids[0]}")
    page.should have_css(".answer input#answer_#{aids[1]}")
    page.should have_css(".answer input#answer_#{aids[2]}")
    page.should have_css(".answer input#answer_#{aids[3]}")

    # Make sure the correct dashboard steps were used.

    steps = global_json['chart']['dashboard_steps']

    steps.should have(2).elements

    steps[ question_set.dashboard_items[0].gquery ].should \
      eql( question_set.dashboard_items[0].steps.split(',').map(&:to_f) )

    steps[ question_set.dashboard_items[1].gquery ].should \
      eql( question_set.dashboard_items[1].steps.split(',').map(&:to_f) )
  end

  scenario 'Does not show questions from other question sets' do
    other_set = create :full_question_set

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


end
