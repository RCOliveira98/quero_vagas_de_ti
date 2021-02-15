class CompanyAdmin < ApplicationRecord
  belongs_to :employee
  belongs_to :company

  def self.create_or_find_admin(admin)
    if admin && admin.class.to_s == 'Employee'
      company = Company.find(admin.company_id)
      first_employee = company.employees.first

      if first_employee && admin.id == first_employee.id
        return CompanyAdmin.create(employee: admin, company: company)
      end
      return first_employee
    end
    false
  end
end
