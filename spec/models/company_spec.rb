require 'rails_helper'

RSpec.describe Company, type: :model do

 describe 'validations' do
  it 'is not valid without an email suffix' do
    company = Company.new

    expect(company.valid?).to eq false
  end

  it 'is valid with an email suffix' do
    company = Company.new(email_sufix: '@rebase.com.br')

    expect(company.valid?).to eq true
  end
 end

 describe '.find_or_create' do
  it 'find' do
    Company.create!(email_sufix: '@rebase.com.br')
    Company.create!(email_sufix: '@vindi.com.br')
    Company.create!(email_sufix: '@portalsolar.com.br')
    smartfit_company = Company.create!(email_sufix: '@smartfit.com.br')
    Company.create!(email_sufix: '@konduto.com.br')
    different_company = Company.create!(email_sufix: '@campuscode.com.br')

    company_found = Company.find_or_create('@smartfit.com.br')

    expect(company_found).to eq smartfit_company
    expect(company_found).not_to eq different_company
  end

  it 'create' do
    rebase_company = Company.create!(email_sufix: '@rebase.com.br')
    vindi_company = Company.create!(email_sufix: '@vindi.com.br')
    portal_solar_company = Company.create!(email_sufix: '@portalsolar.com.br')
    smartfit_company = Company.create!(email_sufix: '@smartfit.com.br')
    konduto_company = Company.create!(email_sufix: '@konduto.com.br')

    company_created = Company.find_or_create('@campuscode.com.br')

    expect(company_created).not_to eq rebase_company
    expect(company_created).not_to eq vindi_company
    expect(company_created).not_to eq portal_solar_company
    expect(company_created).not_to eq smartfit_company
    expect(company_created).not_to eq konduto_company

    expect(company_created).to eq Company.find_or_create('@campuscode.com.br')
  end

 end

end
