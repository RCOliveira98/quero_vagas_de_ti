require 'rails_helper'

feature 'employee create account' do

  scenario 'Success' do
    visit root_path

    click_on 'Criar conta'

    expect(current_path).to eq new_employee_registration_path()

    expect(page).to have_content('Novo usuário')

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

    click_on 'Criar conta'

    expect(current_path).to eq new_employee_registration_path()

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

    click_on 'Criar conta'

    expect(current_path).to eq new_employee_registration_path()

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

    click_on 'Criar conta'

    expect(current_path).to eq new_employee_registration_path()

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
    Employee.create!(email: 'romario.ti@rco.com.br', password: '123456')
    visit root_path

    click_on 'Criar conta'

    expect(current_path).to eq new_employee_registration_path()

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

end