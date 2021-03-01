require 'rails_helper'

feature 'job seekers consult their applications' do
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
        visit candidates_backoffice_applications_path
        expect(current_path).not_to eq candidates_backoffice_applications_path
        expect(current_path).to eq new_candidate_session_path
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

        login_as(candidate, scope: :candidate)

        visit candidates_backoffice_root_path
        click_on 'Candidaturas'
        expect(current_path).to eq candidates_backoffice_applications_path
        expect(page).to have_content('Minhas candidaturas')
        expect(page).to have_content(application.job.title)
        expect(page).to have_content(application.job.description)
        expect(page).to have_content(application.created_at)
        expect(page).to have_content('Aguardando resposta')
    end

    scenario 'index with many items' do
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

        other_job = Job.create!(title: 'Programador Java',
            description: 'Vaga para programador java',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )

        last_job = Job.create!(title: 'Programador Java',
            description: 'Vaga para programador java',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )

        application = Application.create(candidate: candidate, job: job)
        other_application = Application.create(candidate: candidate, job: other_job)
        DeclineApplication.create!(application: other_application, employee: employee, justification: 'Perfil não atende')
        last_application = Application.create(candidate: candidate, job: last_job)
        Proposal.create!(application: last_application, employee: employee,
            message: 'Venha fazer parte do nosso time',
            start_date: DateTime.new(2021, 4, 20, 8, 0),
            salary_proposal: 2000
        )
        login_as(candidate, scope: :candidate)

        visit candidates_backoffice_applications_path
        expect(page).to have_content('Minhas candidaturas')

        within("#application_#{application.id}") do
            expect(page).to have_content(application.job.title)
            expect(page).to have_content(application.job.description)
            expect(page).to have_content(application.created_at)
            expect(page).to have_content('Aguardando resposta')
        end

        within("#application_#{other_application.id}") do
            expect(page).to have_content(other_application.job.title)
            expect(page).to have_content(other_application.job.description)
            expect(page).to have_content(other_application.created_at)
            expect(page).not_to have_content('Aguardando resposta')
            expect(page).to have_content('Candidatura declinada')
            expect(page).to have_content("Motivo: #{other_application.decline_application.justification}")
        end

        within("#application_#{last_application.id}") do
            expect(page).to have_content(last_application.job.title)
            expect(page).to have_content(last_application.job.description)
            expect(page).to have_content(last_application.created_at)
            expect(page).to have_content('Proposta recebida')
        end
        
    end

    scenario 'index without any items' do
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

        login_as(candidate, scope: :candidate)

        visit candidates_backoffice_applications_path
        expect(page).to have_content('Minhas candidaturas')
        expect(page).to have_content('Você ainda não se candidatou a nenhuma vaga')
    end
end