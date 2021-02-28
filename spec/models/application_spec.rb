require 'rails_helper'

RSpec.describe Application, type: :model do

  describe '#pending_evaluation?' do
    it 'return true' do
      company = Company.create!(email_suffix: '@rco.com.br', name: 'rco')
      employee = Employee.create!(company: company, name: 'Romário', email: 'romario@rco.com.br', password: '123456')
      job = Job.create!(title: 'Desenvolvedor angular',
        description: 'Vaga para desevolvedor angular',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
        employee_id: employee.id,
        company_id: company.id
      )
      candidate = Candidate.create!(email: 'rauena@gmail.com.br', password: '123456')
      application = Application.create!(candidate: candidate, job: job)

      expect(application.pending_evaluation?).to eq true
    end

    it 'returns false because the proposal was declined' do
      company = Company.create!(email_suffix: '@rco.com.br', name: 'rco')
      employee = Employee.create!(company: company, name: 'Romário', email: 'romario@rco.com.br', password: '123456')
      job = Job.create!(title: 'Desenvolvedor angular',
        description: 'Vaga para desevolvedor angular',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
        employee_id: employee.id,
        company_id: company.id
      )
      candidate = Candidate.create!(email: 'rauena@gmail.com.br', password: '123456')
      application = Application.create!(candidate: candidate, job: job)
      DeclineApplication.create!(application: application, employee: employee, justification: 'Perfil não agradou.')

      expect(application.pending_evaluation?).to eq false
    end

    it 'returns false because the proposal was made' do
      company = Company.create!(email_suffix: '@rco.com.br', name: 'rco')
      employee = Employee.create!(company: company, name: 'Romário', email: 'romario@rco.com.br', password: '123456')
      job = Job.create!(title: 'Desenvolvedor angular',
        description: 'Vaga para desevolvedor angular',
        quantity: 2,
        level: 10,
        lowest_salary: 1800,
        highest_salary: 3000,
        deadline_for_registration: DateTime.new(2021, 3, 20, 23, 59),
        employee_id: employee.id,
        company_id: company.id
      )
      candidate = Candidate.create!(email: 'rauena@gmail.com.br', password: '123456')
      application = Application.create!(candidate: candidate, job: job)
      Proposal.create!(
        application: application,
        employee: employee,
        message: 'Venha fazer parte do nosso time!',
        salary_proposal: 3500,
        start_date: Time.now
      )

      expect(application.pending_evaluation?).to eq false
    end

  end

end
