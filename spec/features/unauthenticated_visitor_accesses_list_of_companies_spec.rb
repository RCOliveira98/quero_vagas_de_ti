require 'rails_helper'

feature 'unauthenticated visitor accesses list of companies' do
    
    scenario 'index' do
        company_rebase = Company.create!(name: 'Rebase', email_suffix: '@rebase.com.br')
        company_vindi = Company.create!(name: 'Vindi', email_suffix: '@vindi.com.br')
        company_portal_solar = Company.create!(name: 'Portal solar', email_suffix: '@portalsolar.com.br')
        company_konduto = Company.create!(name: 'Konduto', email_suffix: '@konduto.com.br')
        company_smartfit = Company.create!(name: 'Smartfit', email_suffix: '@smartfit.com.br')

        visit root_path
        click_on 'Empresas'

        expect(current_path).to eq(companies_path)
        expect(page).to have_content('Empresas cadastradas')

        within("#card_company#{company_rebase.id}") do
            expect(page).to have_content(company_rebase.name)
        end

        within("#card_company#{company_vindi.id}") do
            expect(page).to have_content(company_vindi.name)
        end

        within("#card_company#{company_portal_solar.id}") do
            expect(page).to have_content(company_portal_solar.name)
        end

        within("#card_company#{company_konduto.id}") do
            expect(page).to have_content(company_konduto.name)
        end

        within("#card_company#{company_smartfit.id}") do
            expect(page).to have_content(company_smartfit.name)
        end
        

    end

end