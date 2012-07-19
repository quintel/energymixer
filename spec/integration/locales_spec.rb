require 'spec_helper'

feature 'Locales' do

  # --------------------------------------------------------------------------

  let!(:question_set) { create :full_question_set, name: 'gasmixer' }
  let(:partition) { Partition.named('gasmixer') }

  # --------------------------------------------------------------------------

  scenario 'The default locale' do
    visit 'http://gasmixer.example.com'

    # Correct Language?

    page.should have_css("html[lang='#{ partition.default_locale }']")

    # Footer Links.

    page.should_not have_css(
      "footer a[href*='locale=#{ partition.default_locale }']")

    partition.other_locales(partition.default_locale).each do |locale|
      page.should have_css("footer a[href*='locale=#{ locale }']")
    end
  end

  # --------------------------------------------------------------------------

  scenario 'Specifying a specific, supported language' do
    visit 'http://gasmixer.example.com/?locale=en'

    # Correct Language?

    page.should have_css("html[lang='en']")

    # Footer Links.

    page.should_not have_css("footer a[href*='locale=en']")

    partition.other_locales(:en).each do |locale|
      page.should have_css("footer a[href*='locale=#{ locale }']")
    end
  end

  # --------------------------------------------------------------------------

  scenario 'Specifying a specific, unsupported language' do
    visit 'http://gasmixer.example.com/?locale=nope'

    # Correct Language?

    page.should have_css("html[lang='#{ partition.default_locale }']")

    # Footer Links.

    page.should_not have_css(
      "footer a[href*='locale=#{ partition.default_locale }']")

    partition.other_locales(partition.default_locale).each do |locale|
      page.should have_css("footer a[href*='locale=#{ locale }']")
    end
  end

  # --------------------------------------------------------------------------

end
