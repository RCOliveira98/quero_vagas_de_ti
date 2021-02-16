require 'rails_helper'

RSpec.describe CompanyAdmin, type: :model do
  describe 'Validations' do

    it 'attributes cannot be blank' do
      company_admin = CompanyAdmin.new

      expect(company_admin.valid?).to eq false
    end

    it 'is not valid without company_id' do
      employee = Employee.create(email: 'rco@treinadev.com.br', password: '123456')
      company_admin = CompanyAdmin.new(employee_id: employee.id)

      expect(company_admin.valid?).to eq false
    end

    it 'is not valid without employee_id' do
      company = Company.create!(email_suffix: '@treinadev.com.br')
      company_admin = CompanyAdmin.new(company_id: company.id)

      expect(company_admin.valid?).to eq false
    end

    it 'is valid with employee_id e company_id' do
      company = Company.create!(email_suffix: '@treinadev.com.br')
      employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company_id: company.id)
      company_admin = CompanyAdmin.new(employee: employee, company: company)

      expect(company_admin.valid?).to eq true
    end
  end

  describe '.create_or_find_admin' do

    it 'success' do
      company = Company.create!(email_suffix: '@treinadev.com.br')
      employee = Employee.create!(email: 'romario@treinadev.com.br', password: '123456', company: company)
      company_admin = CompanyAdmin.create_or_find_admin(employee)

      expect(employee.id).to eq company_admin.id
    end

    it 'this should not be the admin' do
      company = Company.create!(email_suffix: '@treinadev.com.br')
      Employee.create!(email: 'romario@treinadev.com.br', password: '123456', company: company)
      employee = Employee.create!(email: 'joao@treinadev.com.br', password: '123456', company: company)
      company_admin = CompanyAdmin.create_or_find_admin(employee)

      expect(employee.id).not_to eq company_admin.id
    end
  end
end
