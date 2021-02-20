require 'rails_helper'

require 'util_module_app'

feature 'employee create account' do

  scenario 'Success' do
    visit root_path

    click_on 'Recrutador'

    expect(current_path).to eq new_employee_session_path()

    click_on 'Criar conta'

    within('form') do
      fill_in 'E-mail', with: 'romario.ti@rco.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de senha', with: '123456'
      click_on 'Cadastrar'
    end

    expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso')
    expect(page).to have_content('romario.ti@rco.com.br')
    expect(page).to have_content('Sair')

    expect(page).not_to have_content('Criar conta')
  end

  scenario 'password confirmation failed' do
    visit root_path

    click_on 'Recrutador'

    expect(current_path).to eq new_employee_session_path()

    click_on 'Criar conta'

    expect(page).to have_content('Novo usuário')

    within('form') do
      fill_in 'E-mail', with: 'romario.ti@rco.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de senha', with: '123458'
      click_on 'Cadastrar'
    end

    expect(page).to have_content('Confirmação de senha não é igual a Senha')

    expect(page).not_to have_content('Bem vindo! Você realizou seu registro com sucesso')
    expect(page).not_to have_content('romario.ti@rco.com.br')
    expect(page).not_to have_content('Sair')
  end

  scenario 'the password is too short' do
    visit root_path

    click_on 'Recrutador'

    expect(current_path).to eq new_employee_session_path()

    click_on 'Criar conta'

    expect(page).to have_content('Novo usuário')
    
    within('form') do
      fill_in 'E-mail', with: 'romario.ti@rco.com.br'
      fill_in 'Senha', with: '12345'
      fill_in 'Confirmação de senha', with: '12345'
      click_on 'Cadastrar'
    end

    expect(page).to have_content('Senha é muito curto')
    expect(page).not_to have_content('Bem vindo! Você realizou seu registro com sucesso')
    expect(page).not_to have_content('romario.ti@rco.com.br')
    expect(page).not_to have_content('Sair')
  
  end

  scenario 'Password cannot be empty' do
    visit root_path

    click_on 'Recrutador'

    expect(current_path).to eq new_employee_session_path()

    click_on 'Criar conta'

    expect(page).to have_content('Novo usuário')
    
    within('form') do
      fill_in 'E-mail', with: 'romario.ti@rco.com.br'
      fill_in 'Senha', with: ''
      fill_in 'Confirmação de senha', with: ''
      click_on 'Cadastrar'
    end

    expect(page).to have_content('Senha não pode ficar em branco')
    expect(page).not_to have_content('Bem vindo! Você realizou seu registro com sucesso')
    expect(page).not_to have_content('romario.ti@rco.com.br')
    expect(page).not_to have_content('Sair')
  
  end

  scenario 'the email is already being used' do
    company = Company.create!(email_suffix: 'rco.com.br')
    Employee.create!(email: 'romario.ti@rco.com.br', password: '123456', company: company)
    visit root_path

    click_on 'Recrutador'

    expect(current_path).to eq new_employee_session_path()

    click_on 'Criar conta'

    expect(page).to have_content('Novo usuário')
    
    within('form') do
      fill_in 'E-mail', with: 'romario.ti@rco.com.br'
      fill_in 'Senha', with: '654321'
      fill_in 'Confirmação de senha', with: '654321'
      click_on 'Cadastrar'
    end

    expect(page).to have_content('E-mail já está em uso')
    expect(page).not_to have_content('Bem vindo! Você realizou seu registro com sucesso')
    expect(page).not_to have_content('romario.ti@rco.com.br')
    expect(page).not_to have_content('Sair')
  
  end

  scenario 'non-corporate email' do
    include UtilModuleApp
    company = Company.create!(email_suffix: 'rco.com.br')
    Employee.create!(email: 'romario.ti@rco.com.br', password: '123456', company: company)
    emails = UtilModuleApp::NON_CORPORATE_EMAILS
  
    visit root_path

    click_on 'Recrutador'

    expect(current_path).to eq new_employee_session_path()

    click_on 'Criar conta'

    emails.each do |email_key, email_value|
      expect(page).to have_content('Novo usuário')
    
      within('form') do
        fill_in 'E-mail', with: "romario.ti#{email_value}"
        fill_in 'Senha', with: '654321'
        fill_in 'Confirmação de senha', with: '654321'
        click_on 'Cadastrar'
      end

      expect(page).to have_content('Esse e-mail não é corporativo!')
      expect(page).not_to have_content('Bem vindo! Você realizou seu registro com sucesso')
      expect(page).not_to have_content("romario.ti#{email_value}")
      expect(page).not_to have_content('Sair')
    end
  end

end