require 'rails_helper'

feature 'apply for a job' do
    scenario 'unauthenticated user' do
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

        visit root_path
        click_on 'Empresas'
        click_on 'vagas'
        find("#job_#{job.id}") do
            click_on 'Candidatar-se' 
        end

        expect(current_path).to eq new_candidate_session_path
        
        within('form') do
            fill_in 'E-mail', with: candidate.email
            fill_in 'Senha', with: '123456'
            click_on 'Entrar'
        end

        expect(current_path).to eq candidates_backoffice_job_path(job)
        click_on 'Confirmar candidatura'
        expect(current_path).to eq candidates_backoffice_applications_path
        expect(page).to have_content('Candidatura enviada!')

        expect(page).to have_content(job.id)
        expect(page).to have_content(job.title)
        expect(page).to have_content(job.description)
    end

    scenario 'unregistered candidate' do
        company = Company.create!(name: 'treinadev', email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)
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

        visit root_path
        click_on 'Empresas'
        click_on 'vagas'
        find("#job_#{job.id}") do
            click_on 'Candidatar-se' 
        end

        expect(current_path).to eq new_candidate_session_path
        click_on 'Criar conta'
        expect(current_path).to eq new_candidate_registration_path
        
        within('form') do
            fill_in 'E-mail', with: 'romario@gmail.com'
            fill_in 'Senha', with: '123456'
            fill_in 'Confirmação de senha', with: '123456'
            click_on 'Cadastrar'
        end

        expect(current_path).to eq candidates_backoffice_job_path(job)
        click_on 'Confirmar candidatura'
        expect(current_path).to eq candidates_backoffice_applications_path
        expect(page).to have_content('Candidatura enviada!')

        expect(page).to have_content(job.id)
        expect(page).to have_content(job.title)
        expect(page).to have_content(job.description)
    end

    scenario 'authenticated candidate' do
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
        visit candidates_backoffice_root_path

        click_on 'Empresas'
        click_on 'vagas'
        find("#job_#{job.id}") do
            click_on 'Candidatar-se' 
        end

        expect(current_path).to eq candidates_backoffice_job_path(job)
        click_on 'Confirmar candidatura'
        expect(current_path).to eq candidates_backoffice_applications_path
        expect(page).to have_content('Candidatura enviada!')

        expect(page).to have_content(job.id)
        expect(page).to have_content(job.title)
        expect(page).to have_content(job.description)
    end

end