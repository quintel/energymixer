require 'spec_helper'

feature 'When no matching partition exists' do
  scenario 'Visiting the root page' do
    running_this = -> { visit 'http://invalid.example.com/' }
    expect(&running_this).to raise_error(/no such partition/i)
  end
end
