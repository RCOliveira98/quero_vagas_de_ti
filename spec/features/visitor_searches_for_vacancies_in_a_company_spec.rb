require 'rails_helper'

feature 'Visitor searches for vacancies in a company' do

    scenario 'there is no need to login' do
        visit root_path
        click_on 'Empresas'
        expect(current_path).to eq(companies_path)
        expect(page).to have_content('Nenhuma empresa cadastrada')
    end

    scenario 'Company Profile' do
        company_other = Company.create!(name: 'Armazém Paraíba', email_suffix: '@paraiba.com.br')
        company = Company.create!(name: 'Casas Bahia', email_suffix: '@casasbahia.com.br')
        employee = Employee.create!(company: company, email: 'romario@casasbahia.com.br',
            name: 'Romário', password: '123456')
        job_java = Job.create!(title: 'Analista java',
            description: 'Vaga para analista java',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )
        job_ruby = Job.create!(title: 'Programador ruby',
            description: 'Vaga para para programador ruby',
            quantity: 1,
            level: 10,
            lowest_salary: 2200,
            highest_salary: 3500,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )

        visit root_path
        click_on 'Empresas'
        within("#card_company#{company.id}") do
            click_on 'vagas'
        end

        expect(current_path).to eq profile_company_path(company.id)
        expect(page).to have_content(company.name)
        expect(page).not_to have_content(company_other.name)
        expect(page).to have_content('Vagas disponíveis')

        within("#company_job#{job_java.id}") do
            expect(page).to have_content(job_java.title)
            expect(page).to have_content(job_java.description)
        end

        within("#company_job#{job_ruby.id}") do
            expect(page).to have_content(job_ruby.title)
            expect(page).to have_content(job_ruby.description)
        end
    end

    scenario 'search job vacancy by title' do
        company = Company.create!(name: 'Casas Bahia', email_suffix: '@casasbahia.com.br')
        employee = Employee.create!(company: company, email: 'romario@casasbahia.com.br',
            name: 'Romário', password: '123456')
        job_java = Job.create!(title: 'Analista java',
            description: 'Vaga para analista java',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )
        job_ruby = Job.create!(title: 'Programador ruby',
            description: 'Vaga para para programador ruby',
            quantity: 1,
            level: 10,
            lowest_salary: 2200,
            highest_salary: 3500,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )

        visit root_path
        click_on 'Empresas'
        expect(current_path).to eq(companies_path)
        within("#card_company#{company.id}") do
            click_on 'vagas'
        end

        expect(current_path).to eq profile_company_path(company.id)
        within('form') do
            fill_in 'Buscar', with: 'ruby'
            click_on 'Pesquisar'
        end
        expect(current_path).to eq jobs_company_path(company.id)
        expect(page).not_to have_content(job_java.title)
        expect(page).to have_content(job_ruby.title)

    end
end