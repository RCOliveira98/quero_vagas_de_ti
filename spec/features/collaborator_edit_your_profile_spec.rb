require 'rails_helper'

feature 'collaborator edit your profile' do
    
    scenario 'Success' do
        company = Company.create!(email_suffix: '@americanas.com.br')
        employee = Employee.create!(email: 'rco@americanas.com.br',
            password: '123456',
            name: 'Rauena Coelho Oliveira',
            company_id: 1)
        CompanyAdmin.create_or_find_admin(employee)

        login_as(employee, scope: :employee)

        visit employees_backoffice_employee_path(employee)

        expect(current_path).to eq(employees_backoffice_employee_path(employee))
        expect(page).to have_content('Perfil do usuário')
        click_link 'Editar'

        expect(current_path).to eq(edit_employees_backoffice_employee_path(employee))
        within('form') do
            fill_in('E-mail', with: employee.email)
            fill_in('Nome', with: 'Romário Coelho Oliveira')
            click_on 'Atualizar'
        end

        expect(page).to have_content('Perfil atualizado!')
        employee.reload
        expect(current_path).to eq(employees_backoffice_employee_path(employee))
        
        within('.card') do
            expect(page).to have_content(employee.email)
            expect(page).to have_content(employee.name)
        end

    end

    scenario 'mandatory attributes cannot be blank' do
        company = Company.create!(email_suffix: '@americanas.com.br')
        employee = Employee.create!(email: 'rco@americanas.com.br',
            password: '123456',
            name: 'Rauena Coelho Oliveira',
            company_id: 1)
        CompanyAdmin.create_or_find_admin(employee)

        login_as(employee, scope: :employee)

        visit employees_backoffice_employee_path(employee)

        expect(current_path).to eq(employees_backoffice_employee_path(employee))
        expect(page).to have_content('Perfil do usuário')
        click_link 'Editar'

        expect(current_path).to eq(edit_employees_backoffice_employee_path(employee))
        within('form') do
            fill_in('E-mail', with: employee.email)
            fill_in('Nome', with: '')
            click_on 'Atualizar'
        end

        expect(page).to have_content('Nome não pode ficar em branco')
    end

end