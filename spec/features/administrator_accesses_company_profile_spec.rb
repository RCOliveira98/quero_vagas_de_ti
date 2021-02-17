require 'rails_helper'

feature 'administrator accesses company profile' do

    scenario 'the admin must be logged in' do
        Company.create!(email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company_id: 1)

        visit profile_employees_backoffice_company_path(id: 1)

        expect(current_path).not_to eq profile_employees_backoffice_company_path(id: 1)
        expect(current_path).to eq new_employee_session_path()
    end

    scenario 'success' do
        company = Company.create!(email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company_id: 1)
        CompanyAdmin.create_or_find_admin(employee)
        employee.reload

        login_as(employee, scope: :employee)

        visit root_path
        click_on 'perfil da empresa'

        expect(current_path).to eq profile_employees_backoffice_company_path(id: 1)

        expect(page).to have_content(company.email_suffix)
        expect(page).to have_content(company.name)
        expect(page).to have_content(company.cnpj)
        expect(page).to have_content(company.site)
        expect(page).to have_content(company.country)
        expect(page).to have_content(company.state)
        expect(page).to have_content(company.city)
        expect(page).to have_content(company.zip_code)
        expect(page).to have_content(company.neighborhood)
        expect(page).to have_content(company.logradouro)
        expect(page).to have_content(company.created_at)
        expect(page).to have_content(company.updated_at)

    end
end