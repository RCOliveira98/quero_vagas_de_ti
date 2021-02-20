require 'rails_helper'

feature 'visitor survey by company' do
    scenario 'returns multiple companies' do
        company_rebase = Company.create!(name: 'RebaseTech', email_suffix: '@rebase.com.br')
        company_vindi = Company.create!(name: 'VindiTech', email_suffix: '@vindi.com.br')
        company_portal_solar = Company.create!(name: 'Portal solar', email_suffix: '@portalsolar.com.br')
        company_konduto = Company.create!(name: 'KondutoTech', email_suffix: '@konduto.com.br')
        company_smartfit = Company.create!(name: 'Smartfit', email_suffix: '@smartfit.com.br')

        visit root_path
        click_on 'Empresas'

        within('form') do
            fill_in('Buscar', with: 'Tech')
            click_on 'Pesquisar'
        end

        expect(current_path).to eq(search_name_companies_path)
        expect(page).to have_content('Resultado da busca:')

        within("#card_company#{company_rebase.id}") do
            expect(page).to have_content(company_rebase.name)
        end

        within("#card_company#{company_vindi.id}") do
            expect(page).to have_content(company_vindi.name)
        end

        within("#card_company#{company_konduto.id}") do
            expect(page).to have_content(company_konduto.name)
        end

        expect(page).not_to have_content(company_smartfit.name)
        expect(page).not_to have_content(company_portal_solar.name)

    end

    scenario 'returns a single company' do

        company_rebase = Company.create!(name: 'Rebase', email_suffix: '@rebase.com.br')
        company_vindi = Company.create!(name: 'Vindi', email_suffix: '@vindi.com.br')
        company_portal_solar = Company.create!(name: 'Portal solar soft', email_suffix: '@portalsolar.com.br')
        company_konduto = Company.create!(name: 'Konduto', email_suffix: '@konduto.com.br')
        company_smartfit = Company.create!(name: 'Smartfit', email_suffix: '@smartfit.com.br')

        visit root_path
        click_on 'Empresas'

        within('form') do
            fill_in('Buscar', with: 'soft')
            click_on 'Pesquisar'
        end

        expect(current_path).to eq(search_name_companies_path)
        expect(page).to have_content('Resultado da busca:')

        within("#card_company#{company_portal_solar.id}") do
            expect(page).to have_content(company_portal_solar.name)
        end

        expect(page).not_to have_content(company_vindi.name)
        expect(page).not_to have_content(company_konduto.name)
        expect(page).not_to have_content(company_smartfit.name)
        expect(page).not_to have_content(company_rebase.name)
        
    end

    scenario "I can't find the company" do
        company_rebase = Company.create!(name: 'Rebase', email_suffix: '@rebase.com.br')
        company_vindi = Company.create!(name: 'Vindi', email_suffix: '@vindi.com.br')
        company_portal_solar = Company.create!(name: 'Portal solar', email_suffix: '@portalsolar.com.br')
        company_konduto = Company.create!(name: 'Konduto', email_suffix: '@konduto.com.br')
        company_smartfit = Company.create!(name: 'Smartfit', email_suffix: '@smartfit.com.br')

        visit root_path
        click_on 'Empresas'

        within('form') do
            fill_in('Buscar', with: 'campus code')
            click_on 'Pesquisar'
        end

        expect(current_path).to eq(search_name_companies_path)
        expect(page).to have_content('Nenhuma empresa foi encontrada')

        expect(page).not_to have_content(company_vindi.name)
        expect(page).not_to have_content(company_konduto.name)
        expect(page).not_to have_content(company_smartfit.name)
        expect(page).not_to have_content(company_rebase.name)
        expect(page).not_to have_content(company_portal_solar.name)
    end

    scenario 'companies all' do
        company_rebase = Company.create!(name: 'Rebase', email_suffix: '@rebase.com.br')
        company_vindi = Company.create!(name: 'Vindi', email_suffix: '@vindi.com.br')
        company_portal_solar = Company.create!(name: 'Portal solar', email_suffix: '@portalsolar.com.br')
        company_konduto = Company.create!(name: 'Konduto', email_suffix: '@konduto.com.br')
        company_smartfit = Company.create!(name: 'Smartfit', email_suffix: '@smartfit.com.br')

        visit root_path
        click_on 'Empresas'

        within('form') do
            fill_in('Buscar', with: 'campus code')
            click_on 'Pesquisar'
        end

        expect(current_path).to eq(search_name_companies_path)
        expect(page).to have_content('Nenhuma empresa foi encontrada')
        click_on "Todas"
        expect(current_path).to eq(companies_path)

        expect(page).to have_content(company_vindi.name)
        expect(page).to have_content(company_konduto.name)
        expect(page).to have_content(company_smartfit.name)
        expect(page).to have_content(company_rebase.name)
        expect(page).to have_content(company_portal_solar.name)
    end
end