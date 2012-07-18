require 'spec_helper'

feature 'When no question set exists' do
  scenario 'Visiting the root page' do
    running_this = -> { visit 'http://gasmixer.example.com/' }
    expect(&running_this).to raise_error(/no question set/i)
  end
end
