require 'rails_helper'

feature 'visitor accessed the home page' do
  scenario 'successfully' do
    visit root_path

    expect(page).to have_content('Quero vagas de TI!')
  end
end