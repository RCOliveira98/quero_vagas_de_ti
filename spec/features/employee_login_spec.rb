require 'rails_helper'

feature 'employee login' do
    scenario 'e-mail invalid' do
        company = Company.create!(email_suffix: '@treinadev.com.br')
        Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)

        visit root_path
        click_on 'Recrutador'

        expect(current_path).to eq new_employee_session_path()
        expect(page).to have_content('Autenticação')

        within('form') do
            fill_in 'E-mail', with: 'rco2@treinadev.com.br'
            fill_in 'Senha', with: '123456'
            click_on 'Entrar'
        end

        expect(page).to have_content('E-mail ou senha inválidos')
        expect(page).not_to have_content('Login efetuado com sucesso')
    end

    scenario 'password invalid' do
        company = Company.create!(email_suffix: '@treinadev.com.br')
        Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)

        visit root_path
        click_on 'Recrutador'

        expect(current_path).to eq new_employee_session_path()
        expect(page).to have_content('Autenticação')

        within('form') do
            fill_in 'E-mail', with: 'rco@treinadev.com.br'
            fill_in 'Senha', with: '654321'
            click_on 'Entrar'
        end

        expect(page).to have_content('E-mail ou senha inválidos')
        expect(page).not_to have_content('Login efetuado com sucesso')
    end

    scenario 'attributes cannot be blank' do
        visit root_path
        click_on 'Recrutador'

        expect(current_path).to eq new_employee_session_path()
        expect(page).to have_content('Autenticação')

        within('form') do
            fill_in 'E-mail', with: ''
            fill_in 'Senha', with: ''
            click_on 'Entrar'
        end

        expect(page).to have_content('E-mail ou senha inválidos')
        expect(page).not_to have_content('Login efetuado com sucesso')
    end

    scenario 'link sign up' do
        visit root_path
        click_on 'Recrutador'

        expect(current_path).to eq new_employee_session_path()
        expect(page).to have_content('Autenticação')

        click_on 'Criar conta'
        expect(current_path).to eq new_employee_registration_path()
    end

    scenario 'link forgot password?' do
        visit root_path
        click_on 'Recrutador'

        expect(current_path).to eq new_employee_session_path()
        expect(page).to have_content('Autenticação')

        click_on 'Esqueceu sua senha?'
        expect(current_path).to eq new_employee_password_path()
    end

    scenario 'success' do
        company = Company.create!(email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)

        visit root_path
        click_on 'Recrutador'

        expect(current_path).to eq new_employee_session_path()
        expect(page).to have_content('Autenticação')

        within('form') do
            fill_in 'E-mail', with: employee.email
            fill_in 'Senha', with: '123456'
            click_on 'Entrar'
        end

        expect(page).to have_content('Login efetuado com sucesso')
        expect(page).to have_content('Sair')
    end

    scenario 'logout' do
        company = Company.create!(email_suffix: '@treinadev.com.br')
        employee = Employee.create!(email: 'rco@treinadev.com.br', password: '123456', company: company)

        visit root_path
        click_on 'Recrutador'

        expect(current_path).to eq new_employee_session_path()
        expect(page).to have_content('Autenticação')

        within('form') do
            fill_in 'E-mail', with: employee.email
            fill_in 'Senha', with: '123456'
            click_on 'Entrar'
        end

        click_on 'Sair'
        expect(page).to have_content('Criar conta')
        expect(page).to have_content('Entrar')
    end
end