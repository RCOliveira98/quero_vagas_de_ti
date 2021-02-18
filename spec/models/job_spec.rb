require 'rails_helper'

RSpec.describe Job, type: :model do

  describe 'Validations' do
    it 'invalid' do
      job = Job.new

      expect(job.valid?).to eq false
    end

    it 'valid' do
      company = Company.create!(email_suffix: '@rco.com.br')
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
      
      expect(job.valid?).to eq true
    end
  end

  describe '.select_unexpired_jobs_for_a_company' do

    it 'multiple job openings' do
      company = Company.create!(email_suffix: '@rco.com.br')
      employee = Employee.create!(email: 'rauena@rco.com.br', password: '123456', company: company)
      company_other = Company.create!(email_suffix: '@treina.com.br')
      employee_other = Employee.create!(email: 'romario@treina.com.br', password: '123456', company: company_other)

      # id 1
      Job.create!(title: 'Analista java',
                  description: 'Vaga para analista java',
                  quantity: 2,
                  level: 10,
                  lowest_salary: 1800,
                  highest_salary: 3000,
                  deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
                  employee_id: employee.id,
                  company_id: company.id
      )
      # id 2 - essa não deve constar na lista: empresa diferente
      Job.create!(title: 'Programador elixir',
        description: 'Vaga para programador elixir',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
        employee_id: employee_other.id,
        company_id: company_other.id
      )
      # id 3
      Job.create!(title: 'Desenvolvedor angular',
        description: 'Vaga para desevolvedor angular',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
        employee_id: employee.id,
        company_id: company.id
      )
      # id 4 - essa não deve constar na lista: expirou
      Job.create!(title: 'Programador JavaScript',
        description: 'Vaga para programador Js',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2020, 3, 20, 23, 59),
        employee_id: employee.id,
        company_id: company.id
      )
      # id 5
      Job.create!(title: 'Programador ruby',
        description: 'Vaga para programador ruby',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
        employee_id: employee.id,
        company_id: company.id
      )


      jobs = Job.select_unexpired_jobs_for_a_company(company.id)

      expect(jobs.size).to eq 3
      expect(jobs[0].id).to eq 1
      expect(jobs[1].id).to eq 3
      expect(jobs[2].id).to eq 5

      jobs.each do |job|
        expect(job.id).not_to eq 2
        expect(job.id).not_to eq 4
      end
    end

    it 'a single job vacancy' do
      company = Company.create!(email_suffix: '@rco.com.br')
      employee = Employee.create!(email: 'rauena@rco.com.br', password: '123456', company: company)
      company_other = Company.create!(email_suffix: '@treina.com.br')
      employee_other = Employee.create!(email: 'romario@treina.com.br', password: '123456', company: company_other)

      # id 1 - essa não deve constar na lista: empresa diferente
      Job.create!(title: 'Programador elixir',
        description: 'Vaga para programador elixir',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
        employee_id: employee_other.id,
        company_id: company_other.id
      )
      # id 2
      Job.create!(title: 'Desenvolvedor angular',
        description: 'Vaga para desevolvedor angular',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
        employee_id: employee.id,
        company_id: company.id
      )
      # id 3 - essa não deve constar na lista: expirou
      Job.create!(title: 'Programador JavaScript',
        description: 'Vaga para programador Js',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2020, 3, 20, 23, 59),
        employee_id: employee.id,
        company_id: company.id
      )

      jobs = Job.select_unexpired_jobs_for_a_company(company.id)

      expect(jobs.size).to eq 1
      expect(jobs[0].id).to eq 2

      jobs.each do |job|
        expect(job.id).not_to eq 1
        expect(job.id).not_to eq 3
      end

    end

    it 'no job openings' do
      company = Company.create!(email_suffix: '@rco.com.br')
      employee = Employee.create!(email: 'rauena@rco.com.br', password: '123456', company: company)
      company_other = Company.create!(email_suffix: '@treina.com.br')
      employee_other = Employee.create!(email: 'romario@treina.com.br', password: '123456', company: company_other)

      # id 1 - essa não deve constar na lista: empresa diferente
      Job.create!(title: 'Programador elixir',
        description: 'Vaga para programador elixir',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
        employee_id: employee_other.id,
        company_id: company_other.id
      )
      # id 2 - essa não deve constar na lista: expirou
      Job.create!(title: 'Programador JavaScript',
        description: 'Vaga para programador Js',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2020, 3, 20, 23, 59),
        employee_id: employee.id,
        company_id: company.id
      )

      jobs = Job.select_unexpired_jobs_for_a_company(company.id)

      expect(jobs.size).to eq 0
    end

  end

  describe '#creator_of_the_same_company?' do
    it 'true' do
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

      result = job.creator_of_the_same_company?(employee.company_id)
      expect(result).to eq true
    end

    it 'false' do
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

      result = job.creator_of_the_same_company?(employee_other.company_id)
      expect(result).to eq false
    end

  end
end
