require 'rails_helper'

RSpec.describe Employee, type: :model do

  describe "#admin?" do
    it 'is an administrator' do
      company = Company.create!(email_suffix: '@treinadev.com.br')
      employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company_id: 1)
      company_admin = CompanyAdmin.create_or_find_admin(employee)

      expect(employee.admin?).to be_truthy
    end

    it 'non-administrator' do
      company = Company.create!(email_suffix: '@treinadev.com.br')
      employee_admin = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company_id: 1)
      employee = Employee.create!(email: 'joao@treinadev.com.br', password: '123456', company_id: 1)
      CompanyAdmin.create_or_find_admin(employee_admin)

      expect(employee.admin?).to be_falsey
    end
  end

  describe '#admin_company_id' do
    it 'has admin?' do
      company = Company.create!(email_suffix: '@treinadev.com.br')
      outher_company = Company.create!(email_suffix: '@americanas.com.br')
      employee = Employee.create!(email: 'joao@treinadev.com.br', password: '123456', company_id: 1)
      CompanyAdmin.create_or_find_admin(employee)

      expect(employee.admin_company_id).to eq company.id
      expect(employee.admin_company_id).not_to eq outher_company.id
    end
  end

end
