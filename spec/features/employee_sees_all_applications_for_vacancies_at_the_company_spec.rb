require 'rails_helper'

feature 'employee sees all applications for vacancies at the company' do
    scenario 'login is required' do
        visit employees_backoffice_applications_path
        expect(current_path).not_to eq employees_backoffice_applications_path
        expect(current_path).to eq new_employee_session_path
    end

    scenario 'index with only one item' do
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

        visit employees_backoffice_applications_path
        expect(current_path).to eq employees_backoffice_applications_path

        expect(page).to have_content(job.title)
        expect(page).to have_content(application.id)
        expect(page).to have_content('Analisar candidatura')
    end

    scenario 'index with multiple items' do
        company = Company.create!(name: 'treinadev', email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)
        Candidate.create!(email: 'rauena@gmail.com', password: '123456')
        Candidate.create!(email: 'vitor@gmail.com', password: '123456')
        Candidate.create!(email: 'maria@gmail.com', password: '123456')

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

        first_application = Application.create!(candidate_id: 1, job: job)
        second_application = Application.create!(candidate_id: 2, job: job)
        last_application = Application.create!(candidate_id: 3, job: job)

        login_as(employee, scope: :employee)

        visit employees_backoffice_applications_path
        expect(current_path).to eq employees_backoffice_applications_path

        within("#tr_#{first_application.id}") do
            expect(page).to have_content(first_application.job.title)
            expect(page).to have_content(first_application.id)
            expect(page).to have_content('Analisar candidatura') 
        end

        within("#tr_#{second_application.id}") do
            expect(page).to have_content(second_application.job.title)
            expect(page).to have_content(second_application.id)
            expect(page).to have_content('Analisar candidatura') 
        end

        within("#tr_#{last_application.id}") do
            expect(page).to have_content(last_application.job.title)
            expect(page).to have_content(last_application.id)
            expect(page).to have_content('Analisar candidatura') 
        end
    end

    scenario 'index without any items' do
        company = Company.create!(name: 'treinadev', email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)

        login_as(employee, scope: :employee)

        visit employees_backoffice_applications_path
        expect(current_path).to eq employees_backoffice_applications_path

        expect(page).to have_content('Até agora nenhuma candidatura foi recebida')
    end

    scenario 'index only with registration for vacancies in your company' do
        company = Company.create!(name: 'treinadev', email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)

        other_company = Company.create!(name: 'campuscode', email_suffix: '@campuscode.com.br')
        other_employee = Employee.create!(email: 'raul@campuscode.com.br', password: '123456', company: company)
        Candidate.create!(email: 'rauena@gmail.com', password: '123456')
        Candidate.create!(email: 'vitor@gmail.com', password: '123456')
        Candidate.create!(email: 'maria@gmail.com', password: '123456')

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

        job_other_company = Job.create!(title: 'Programador Elixir',
            description: 'Vaga para programador elixir',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: other_employee.id,
            company_id: other_company.id
        )

        first_application = Application.create!(candidate_id: 1, job: job)
        second_application = Application.create!(candidate_id: 2, job: job_other_company)
        last_application = Application.create!(candidate_id: 3, job: job)

        login_as(employee, scope: :employee)

        visit employees_backoffice_applications_path
        expect(current_path).to eq employees_backoffice_applications_path

        within("#tr_#{first_application.id}") do
            expect(page).to have_content(first_application.job.title)
            expect(page).to have_content(first_application.id)
            expect(page).to have_content('Analisar candidatura') 
        end

        expect(page).not_to have_content(second_application.job.title)
        expect(page).not_to have_content(second_application.id)

        within("#tr_#{last_application.id}") do
            expect(page).to have_content(last_application.job.title)
            expect(page).to have_content(last_application.id)
            expect(page).to have_content('Analisar candidatura') 
        end
    end
end