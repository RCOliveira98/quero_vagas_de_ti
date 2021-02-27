require 'rails_helper'

feature 'employee evaluates job application' do
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

        visit employees_backoffice_application_path(application)
        expect(current_path).to eq(new_employee_session_path)
    end

    scenario 'success' do
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

        application = Application.create!(candidate: candidate, job: job)
        login_as(employee, scope: :employee)

        visit employees_backoffice_application_path(application)
        expect(current_path).to eq employees_backoffice_application_path(application)
        within('.card .card-header .card-header-title') do
           expect(page).to have_content('Avaliar candidatura') 
        end
    end

    scenario 'display job application data' do
        company = Company.create!(name: 'treinadev', email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)
        candidate = Candidate.create!(email: 'rauena@gmail.com', password: '123456')
        other_candidate = Candidate.create!(email: 'raul@gmail.com', password: '123456')
        
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

        application = Application.create!(candidate: candidate, job: job)
        other_application = Application.create!(candidate: other_candidate, job: job)

        login_as(employee, scope: :employee)

        visit employees_backoffice_root_path
        click_on 'Candidaturas'
        expect(page).to have_content('Listagem das candidaturas')

        within("#card_#{other_application.id} .card .card-footer .card-footer-item") do
           click_on 'Analisar candidatura'
        end

        expect(current_path).to eq employees_backoffice_application_path(other_application)
        
        expect(page).to have_content("id da candidatura: #{other_application.id}")
        expect(page).to have_content("id do candidato: #{other_application.candidate.id}")
        expect(page).to have_content(other_application.candidate.candidate_profile&.name)
        expect(page).to have_content(other_application.job.title)
        expect(page).to have_content(other_application.job.description)
        expect(page).to have_content(other_application.candidate.id)

        expect(page).not_to have_content("id da candidatura: #{application.id}")

    end
end