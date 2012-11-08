require 'spec_helper'

feature 'When no matching partition exists' do
  scenario 'Visiting the root page' do
    visit 'http://invalid.example.com/'
    expect(page).to have_content('Bad partition')
  end
end
