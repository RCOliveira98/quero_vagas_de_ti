require 'rails_helper'

feature 'candidate consults proposals' do
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
        proposal = Proposal.create!(application: application, employee: employee,
        message: 'Venha fazer parte do nosso time',
        start_date: DateTime.new(2021, 4, 20, 8, 0),
        salary_proposal: 2000
        )

        visit candidates_backoffice_proposals_path()
        expect(current_path).to eq new_candidate_session_path
    end

    scenario 'just a proposal' do
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
        proposal = Proposal.create!(application: application, employee: employee,
        message: 'Venha fazer parte do nosso time',
        start_date: DateTime.new(2021, 4, 20, 8, 0),
        salary_proposal: 2000
        )
        login_as(candidate, scope: :candidate)

        visit candidates_backoffice_proposals_path()
        expect(page).to have_content('Minhas propostas')

        within("#proposal_#{proposal.id}") do
            expect(page).to have_content(proposal.id)
            expect(page).to have_content(proposal.start_date)
            expect(page).to have_content(proposal.salary_proposal)
            expect(page).to have_content(proposal.message)
        end
    end

    scenario 'several proposals' do
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

        other_job = Job.create!(title: 'Programador JavaScript',
            description: 'Vaga para programador JavaScript',
            quantity: 2,
            level: 10,
            lowest_salary: 1400,
            highest_salary: 2400,
            deadline_for_registration: DateTime.new(2021, 10, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id
        )

        application = Application.create(candidate: candidate, job: job)
        other_application = Application.create(candidate: candidate, job: other_job)

        proposal = Proposal.create!(application: application, employee: employee,
        message: 'Venha fazer parte do nosso time',
        start_date: DateTime.new(2021, 4, 20, 8, 0),
        salary_proposal: 2000
        )

        other_proposal = Proposal.create!(application: other_application, employee: employee,
            message: 'Venha fazer parte do nosso time',
            start_date: DateTime.new(2021, 4, 20, 8, 0),
            salary_proposal: 2000
        )
        login_as(candidate, scope: :candidate)

        visit candidates_backoffice_proposals_path()
        expect(page).to have_content('Minhas propostas')

        within("#proposal_#{proposal.id}") do
            expect(page).to have_content(proposal.id)
            expect(page).to have_content(proposal.start_date)
            expect(page).to have_content(proposal.salary_proposal)
            expect(page).to have_content(proposal.message)
        end

        within("#proposal_#{other_proposal.id}") do
            expect(page).to have_content(other_proposal.id)
            expect(page).to have_content(other_proposal.start_date)
            expect(page).to have_content(other_proposal.salary_proposal)
            expect(page).to have_content(other_proposal.message)
        end
    end

    scenario 'no proposal' do
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

        visit candidates_backoffice_proposals_path()
        expect(page).to have_content('Nenhuma proposta até o momento')
    end
end