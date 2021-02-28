require 'rails_helper'

feature 'employee makes a job offer' do
    scenario 'login is required' do
        company = Company.create!(name: 'treinadev', email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)
        candidate = Candidate.create!(email: 'rauena@gmail.com', password: '123456')
        job = Job.create!(title: 'Programador Ruby',
            description: 'Vaga para programador ruby',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )

        application = Application.create(candidate: candidate, job: job)

        visit employees_backoffice_proposal_path(application)
        expect(current_path).to eq(new_employee_session_path)
    end

    scenario 'access page to create proposal' do
        company = Company.create!(name: 'treinadev', email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)
        candidate = Candidate.create!(email: 'rauena@gmail.com', password: '123456')
        job = Job.create!(title: 'Programador Ruby',
            description: 'Vaga para programador ruby',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )

        application = Application.create(candidate: candidate, job: job)
        login_as(employee, scope: :employee)

        visit employees_backoffice_root_path
        click_on 'Candidaturas'
        find("#card_#{application.id}") do
            click_on 'Analisar candidatura'
        end
        expect(page).to have_content(application.job.title)
        click_on 'Enviar proposta'
        expect(current_path).to eq employees_backoffice_proposal_path(application)
    end

    scenario 'Proposal sent' do
        company = Company.create!(name: 'treinadev', email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)
        candidate = Candidate.create!(email: 'rauena@gmail.com', password: '123456')
        job = Job.create!(title: 'Programador Ruby',
            description: 'Vaga para programador ruby',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )

        application = Application.create(candidate: candidate, job: job)
        login_as(employee, scope: :employee)

        visit employees_backoffice_proposal_path(application)
        expect(page).to have_content('Formulário para envio de proposta')

        find('form') do
            fill_in 'Mensagem', with: 'Venha fazer parte do nosso time!'
            fill_in 'Proposta salarial', with: 2000
            fill_in 'Data de início', with: '08/03/2021 08:00'
            click_on 'Enviar'
        end

        expect(current_path).to eq employees_backoffice_applications_path
        expect(page).to have_content 'Proposta de emprego enviada!'
        expect(page).not_to have_content('Formulário para envio de proposta')

    end

    scenario 'fill in the required fields' do
        company = Company.create!(name: 'treinadev', email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)
        candidate = Candidate.create!(email: 'rauena@gmail.com', password: '123456')
        job = Job.create!(title: 'Programador Ruby',
            description: 'Vaga para programador ruby',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )

        application = Application.create(candidate: candidate, job: job)
        login_as(employee, scope: :employee)

        visit employees_backoffice_proposal_path(application)
        expect(page).to have_content('Formulário para envio de proposta')

        find('form') do
            click_on 'Enviar'
        end

        expect(current_path).not_to eq employees_backoffice_applications_path
        expect(page).not_to have_content 'Proposta de emprego enviada!'
        expect(page).to have_content('Mensagem não pode ficar em branco')
        expect(page).to have_content('Data de início não pode ficar em branco')
        expect(page).to have_content('Proposta salarial não pode ficar em branco')

    end
end