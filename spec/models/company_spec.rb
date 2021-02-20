require 'rails_helper'

RSpec.describe Company, type: :model do

 describe 'validations' do
  it 'is not valid without an email suffix' do
    company = Company.new

    expect(company.valid?).to eq false
  end

  it 'is valid with an email suffix' do
    company = Company.new(email_suffix: '@rebase.com.br')

    expect(company.valid?).to eq true
  end
 end

 describe '.find_or_create' do
  it 'find' do
    Company.create!(email_suffix: '@rebase.com.br')
    Company.create!(email_suffix: '@vindi.com.br')
    Company.create!(email_suffix: '@portalsolar.com.br')
    smartfit_company = Company.create!(email_suffix: '@smartfit.com.br')
    Company.create!(email_suffix: '@konduto.com.br')
    different_company = Company.create!(email_suffix: '@campuscode.com.br')

    company_found = Company.find_or_create('@smartfit.com.br')

    expect(company_found).to eq smartfit_company
    expect(company_found).not_to eq different_company
  end

  it 'create' do
    rebase_company = Company.create!(email_suffix: '@rebase.com.br')
    vindi_company = Company.create!(email_suffix: '@vindi.com.br')
    portal_solar_company = Company.create!(email_suffix: '@portalsolar.com.br')
    smartfit_company = Company.create!(email_suffix: '@smartfit.com.br')
    konduto_company = Company.create!(email_suffix: '@konduto.com.br')

    company_created = Company.find_or_create('@campuscode.com.br')

    expect(company_created).not_to eq rebase_company
    expect(company_created).not_to eq vindi_company
    expect(company_created).not_to eq portal_solar_company
    expect(company_created).not_to eq smartfit_company
    expect(company_created).not_to eq konduto_company

    expect(company_created).to eq Company.find_or_create('@campuscode.com.br')
  end

 end

 describe '.select_by_name' do
   it 'returns several' do
    Company.create!(name: 'Rebase tech', email_suffix: '@rebase.com.br')
    Company.create!(name: 'Vindi', email_suffix: '@vindi.com.br')
    Company.create!(name: 'Portal solar', email_suffix: '@portalsolar.com.br')
    Company.create!(name: 'TechKonduto', email_suffix: '@konduto.com.br')
    Company.create!(name: 'Smartfittech', email_suffix: '@smartfit.com.br')

    companies = Company.select_by_name('tech')
    
    expect(companies.size).to eq 3

    expect(companies[0].id).to eq 1
    expect(companies[1].id).to eq 4
    expect(companies[2].id).to eq 5

    companies.each do |company|
      expect(company.id).not_to eq 2
      expect(company.id).not_to eq 3
    end

   end

   it 'returns one' do
    Company.create!(name: 'Rebase tech', email_suffix: '@rebase.com.br')
    Company.create!(name: 'Vindi', email_suffix: '@vindi.com.br')
    Company.create!(name: 'Portal solar', email_suffix: '@portalsolar.com.br')
    Company.create!(name: 'TechKonduto', email_suffix: '@konduto.com.br')
    Company.create!(name: 'Smartfittech', email_suffix: '@smartfit.com.br')

    companies = Company.select_by_name('vindi')
    
    expect(companies.size).to eq 1    
    expect(companies[0].id).to eq 2

   end

   it 'returns none' do
    Company.create!(name: 'Rebase tech', email_suffix: '@rebase.com.br')
    Company.create!(name: 'Vindi', email_suffix: '@vindi.com.br')
    Company.create!(name: 'Portal solar', email_suffix: '@portalsolar.com.br')
    Company.create!(name: 'TechKonduto', email_suffix: '@konduto.com.br')
    Company.create!(name: 'Smartfittech', email_suffix: '@smartfit.com.br')

    companies = Company.select_by_name('Treinadev')
    
    expect(companies.size).to eq 0   
   end
 end

end
