require 'rails_helper'

feature 'employee decline application' do
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
        application = Application.create!(candidate: candidate, job: job)

        visit employees_backoffice_decline_application_path(application)
        expect(page).not_to have_content('Reprovar candidatura')
        expect(current_path).to eq(new_employee_session_path)
    end

    scenario 'success in accessing the page' do
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
        click_on 'Reprovar'

        expect(page).to have_content('Reprovar candidatura')
        expect(current_path).to eq employees_backoffice_decline_application_path(application)
    end

    scenario 'failed candidate' do
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
        click_on 'Reprovar'

        expect(page).to have_content('Reprovar candidatura')
        find('form') do
            fill_in 'Justificativa', with: 'Não atende aos requisitos'
            click_on 'Confirmar'
        end

        expect(current_path).to eq(employees_backoffice_applications_path)
        expect(page).to have_content('Candidatura reprovada!')
    end
end