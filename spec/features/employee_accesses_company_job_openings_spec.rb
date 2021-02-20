require 'rails_helper'

feature 'employee accesses company job openings' do
    scenario 'login required' do
        visit employees_backoffice_jobs_path

        expect(page).not_to have_content('Vagas de trabalho')
        expect(current_path).to eq(new_employee_session_path)
    end

    scenario 'access the index page successfully' do
        company = Company.create!(email_suffix: '@rco.com.br')
        employee_admin = Employee.create!(email: 'romario@rco.com.br', password: '123456', company: company)
        CompanyAdmin.create_or_find_admin(employee_admin)
        employee = Employee.create!(email: 'rauena@rco.com.br', password: '123456', company: company)

        job = Job.create!(title: 'Analista java',
                    description: 'Vaga para analista java',
                    quantity: 2,
                    level: 10,
                    lowest_salary: 1800,
                    highest_salary: 3000,
                    deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
                    employee_id: employee.id,
                    company_id: company.id
                )

        job_created_admin = Job.create!(title: 'Programador ruby',
            description: 'Vaga para para programador ruby',
            quantity: 1,
            level: 10,
            lowest_salary: 2200,
            highest_salary: 3500,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee_admin.id,
            company_id: company.id
        )

        company_other = Company.create!(email_suffix: '@treina.com.br')
        employee_company_other = Employee.create!(email: 'maria@treina.com.br', password: '123456', company: company_other)
        job_employee_company_other = Job.create!(title: 'Programador elixir',
            description: 'Vaga para para programador elixir',
            quantity: 2,
            level: 10,
            lowest_salary: 2000,
            highest_salary: 3500,
            deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
            employee_id: employee_company_other.id,
            company_id: company_other.id
        )

        login_as(employee, scope: :employee)

        visit employees_backoffice_root_path
        click_link 'Vagas'
        expect(current_path).to eq(employees_backoffice_jobs_path)
        expect(page).to have_content('Vagas de trabalho')

        within('table') do
            expect(page).to have_content(job.title)
            expect(page).to have_content(job.description)
            expect(page).to have_content(job_created_admin.title)
            expect(page).to have_content(job_created_admin.description)
            expect(page).not_to have_content(job_employee_company_other.title)
            expect(page).not_to have_content(job_employee_company_other.description)
        end

    end
end