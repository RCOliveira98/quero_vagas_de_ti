require 'rails_helper'

feature 'employee sees a vacancy' do

  scenario 'login is required' do
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

    visit employees_backoffice_job_path(job)
    expect(current_path).not_to eq employees_backoffice_job_path(job)
    expect(current_path).to eq(new_employee_session_path)
    expect(page).to have_content('Autenticação')
  end
    
  scenario 'Success' do
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
    
    login_as(employee, scope: :employee)

    visit employees_backoffice_root_path
    click_link 'Vagas'
    expect(current_path).to eq employees_backoffice_jobs_path
    within("#tr_#{job.id}") do
      expect(page).to have_content(job.title)
      click_on 'Visualizar'
    end

    expect(current_path).to eq employees_backoffice_job_path(job)

  end

  scenario 'display job vacancy data' do
    company = Company.create!(email_suffix: '@rco.com.br')
    employee = Employee.create!(email: 'romario@rco.com.br',
                                    password: '123456',
                                    company: company)
                    
    job = Job.create!(title: 'Programador Ruby',
      description: 'Vaga para programador ruby',
      quantity: 2,
      level: 10,
      status: 10,
      lowest_salary: 1800,
      highest_salary: 3000,
      deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
      employee_id: employee.id,
      company_id: company.id)
    
    login_as(employee, scope: :employee)

    visit employees_backoffice_job_path(job)
    within("#job#{job.id}") do
      expect(page).to have_content(job.id)
      expect(page).to have_content(job.title)
      expect(page).to have_content(job.description)
      expect(page).to have_content(job.lowest_salary)
      expect(page).to have_content(job.highest_salary)
      expect(page).to have_content(job.level)
      expect(page).to have_content(job.status)
      expect(page).to have_content(job.quantity)
      expect(page).to have_content(job.deadline_for_registration)
      expect(page).to have_content(job.created_at)
      expect(page).to have_content(job.employee.name)
      job.requirements do |requirement|
        expect(page).to have_content(requirement.title)
      end

      expect(page).to have_link('Editar')
      expect(page).to have_link('Voltar')
    end

  end

  scenario 'access job vacancies that do not exist' do
    company = Company.create!(email_suffix: '@rco.com.br')
    employee = Employee.create!(email: 'romario@rco.com.br',
                                    password: '123456',
                                    company: company)
    
    login_as(employee, scope: :employee)

    visit employees_backoffice_job_path(1)
    expect(current_path).to eq employees_backoffice_jobs_path
    expect(page).to have_content 'A vaga de trabalho que tentou acessar não existe!'
  end

  scenario 'back button' do
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
    
    login_as(employee, scope: :employee)

    visit employees_backoffice_job_path(job)
    click_on 'Voltar'
    expect(current_path).to eq(employees_backoffice_jobs_path)

  end

  scenario 'edit button' do
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
    
    login_as(employee, scope: :employee)

    visit employees_backoffice_job_path(job)
    click_on 'Editar'
    expect(current_path).to eq(edit_employees_backoffice_job_path(job))

  end

end