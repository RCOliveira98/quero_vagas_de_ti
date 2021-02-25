require 'rails_helper'

feature 'employee edit job' do

    scenario 'login is required' do
        company = Company.create!(email_suffix: '@rco.com.br')
        employee = Employee.create!(email: 'romario@rco.com.br',
                                    password: '123456',
                                    company: company)
        job = Job.create!(title: 'Analista java',
            description: 'Vaga para analista java',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id)

        visit edit_employees_backoffice_job_path(job)
        expect(current_path).to eq new_employee_session_path()

        login_as(employee, scope: :employee)

        visit edit_employees_backoffice_job_path(job)
        expect(current_path).to eq edit_employees_backoffice_job_path(job)
        expect(page).to have_content('Editar vaga de trabalho')
    end
    
    scenario 'attributes cannot be blank' do
        company = Company.create!(email_suffix: '@rco.com.br')
        employee = Employee.create!(email: 'romario@rco.com.br',
                                    password: '123456',
                                    company: company)

        Job.create!(title: 'Programador Ruby',
            description: 'Vaga para programador ruby',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id)

        job = Job.create!(title: 'Analista java',
            description: 'Vaga para analista java',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id)
        
        login_as(employee, scope: :employee)

        visit employees_backoffice_jobs_path()

        within("table tbody #tr_#{job.id}") do
            click_on "Editar"
        end

        expect(current_path).to eq(edit_employees_backoffice_job_path(job))
        expect(page).to have_content('Editar vaga de trabalho')

        find('form') do
            fill_in('Título', with: '')
            click_on 'Atualizar'
        end

        expect(root_path).not_to eq(employees_backoffice_jobs_path)
        expect(page).to have_content('Título não pode ficar em branco')
    end

    scenario "a company's vacancies can only be edited by its employees" do
        company = Company.create!(email_suffix: '@rco.com.br')
        employee = Employee.create!(email: 'romario@rco.com.br',
                                    password: '123456',
                                    company: company)

        job = Job.create!(title: 'Programador Ruby',
            description: 'Vaga para programador ruby',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id)
        
        company_other = Company.create!(email_suffix: '@treina.com.br')
        employee_other = Employee.create!(email: 'rauena@treina.com.br',
                                    password: '123456',
                                    company: company_other)

        login_as(employee_other, scope: :employee)

        visit edit_employees_backoffice_job_path(job)
        expect(current_path).not_to eq edit_employees_backoffice_job_path(job)
        expect(current_path).to eq employees_backoffice_jobs_path
        expect(page).to have_content('As vagas de uma empresa só podem ser atualizadas por seus funcionários')
    end

    scenario 'success: edit the job offer he created' do
        company = Company.create!(email_suffix: '@rco.com.br')
        employee = Employee.create!(email: 'romario@rco.com.br',
                                    password: '123456',
                                    company: company)

        Job.create!(title: 'Programador Ruby',
            description: 'Vaga para programador ruby',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id)

        job = Job.create!(title: 'Analista java',
            description: 'Vaga para analista java',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id)
        
        login_as(employee, scope: :employee)

        visit employees_backoffice_jobs_path()

        within("table tbody #tr_#{job.id}") do
            click_on "Editar"
        end

        expect(current_path).to eq(edit_employees_backoffice_job_path(job))
        expect(page).to have_content('Editar vaga de trabalho')

        find('form') do
            fill_in('Título', with: 'Programador Java')
            fill_in('Descrição', with: 'Vaga de trabalho para programador Java')
            click_on 'Atualizar'
        end

        expect(current_path).to eq(employees_backoffice_jobs_path)
        expect(page).to have_content('Vaga de trabalho atualizada com sucesso')
    end

    scenario 'success: edit the job offer created by another employee' do
        company = Company.create!(email_suffix: '@rco.com.br')
        employee_creator = Employee.create!(email: 'rauena@rco.com.br',
            password: '123456',
            company: company)
        employee = Employee.create!(email: 'romario@rco.com.br',
                                    password: '123456',
                                    company: company)

        Job.create!(title: 'Programador Ruby',
            description: 'Vaga para programador ruby',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id)

        job = Job.create!(title: 'Analista java',
            description: 'Vaga para analista java',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee_creator.id,
            company_id: company.id)
        
        login_as(employee, scope: :employee)

        visit employees_backoffice_jobs_path()

        within("table tbody #tr_#{job.id}") do
            click_on "Editar"
        end

        expect(current_path).to eq(edit_employees_backoffice_job_path(job))
        expect(page).to have_content('Editar vaga de trabalho')

        find('form') do
            fill_in('Título', with: 'Programador Java')
            fill_in('Descrição', with: 'Vaga de trabalho para programador Java')
            click_on 'Atualizar'
        end

        expect(current_path).to eq(employees_backoffice_jobs_path)
        expect(page).to have_content('Vaga de trabalho atualizada com sucesso')
    end

    scenario 'employee disable jov vacancy' do
        company = Company.create!(email_suffix: '@rco.com.br')
        employee = Employee.create!(email: 'romario@rco.com.br', password: '123456', company: company)

        job = Job.create!(title: 'Analista java',
            description: 'Vaga para analista java',
            quantity: 2,
            level: 10,
            lowest_salary: 1800,
            highest_salary: 3000,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee.id,
            company_id: company.id)

            login_as(employee, scope: :employee)

            visit employees_backoffice_jobs_path()
    
            within("table tbody #tr_#{job.id}") do
                click_on "Editar"
            end
    
            expect(current_path).to eq(edit_employees_backoffice_job_path(job))
            expect(page).to have_content('Editar vaga de trabalho')
    
            find('form') do
                select('Cancelada', from: 'Status')
                click_on 'Atualizar'
            end
    
            expect(current_path).to eq(employees_backoffice_jobs_path)
            expect(page).to have_content('Vaga de trabalho atualizada com sucesso')
    end

end