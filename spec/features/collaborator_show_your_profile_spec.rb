require 'rails_helper'

feature 'collaborator show your profile' do
    
    scenario 'Success' do
        company = Company.create!(email_suffix: '@americanas.com.br')
        employee = Employee.create!(email: 'rco@americanas.com.br',
            password: '123456',
            name: 'Rauena Coelho Oliveira',
            company_id: 1)
        CompanyAdmin.create_or_find_admin(employee)
        employee_outher = Employee.create!(email: 'romario@americanas.com.br',
            password: '123456',
            name: 'Romário Coelho',
            company_id: 1)

        login_as(employee, scope: :employee)

        visit employees_backoffice_root_path

        within('nav') do
            expect(page).to have_content('Perfil')
            click_link 'perfil do usuário'
        end

        expect(current_path).to eq(employees_backoffice_employee_path(employee))
        expect(page).to have_content('Perfil do usuário')

        within('.card') do
            expect(page).to have_content(employee.email)
            expect(page).to have_content(employee.name)
            expect(page).to have_content("Criado em: #{I18n.localize(employee.created_at, :format => :long)}")
            expect(page).to have_content("Atualizado em: #{I18n.localize(employee.updated_at, :format => :long)}")
            expect(page).to have_link('Editar')

            expect(page).not_to have_content(employee_outher.email)
            expect(page).not_to have_content(employee_outher.name)
        end

    end

end