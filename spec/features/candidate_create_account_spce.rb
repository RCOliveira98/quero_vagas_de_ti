require 'rails_helper'

feature 'candidate create account' do
    scenario 'success' do
        visit root_path
        expect(page).to have_content 'Criar conta/Entrar'
        click_on 'Candidato'

        expect(current_path).to eq new_candidate_session_path
        click_on 'Criar conta'

        expect(current_path).to eq new_candidate_registration_path
        within('form') do
            fill_in 'E-mail', with: 'romario.ti@gmail.com.br'
            fill_in 'Senha', with: '123456'
            fill_in 'Confirmação de senha', with: '123456'
            click_on 'Cadastrar'
          end
      
          expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso')
          expect(page).to have_content('romario.ti@gmail.com.br')
          expect(page).to have_content('Sair')
          expect(current_path).to eq candidates_backoffice_root_path
    end

    scenario 'password confirmation failed' do
        visit root_path
    
        click_on 'Candidato'
    
        expect(current_path).to eq new_candidate_session_path()
    
        click_on 'Criar conta'
    
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
    
        click_on 'Candidato'
    
        expect(current_path).to eq new_candidate_session_path()
    
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
    
        click_on 'Candidato'
    
        expect(current_path).to eq new_candidate_session_path()
    
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
        candidate = Candidate.create!(email: 'rco@gmail.com', password: '123456')
        visit root_path
    
        click_on 'Candidato'
    
        expect(current_path).to eq new_candidate_session_path()
    
        click_on 'Criar conta'
    
        expect(page).to have_content('Novo usuário')
        
        within('form') do
          fill_in 'E-mail', with: 'rco@gmail.com'
          fill_in 'Senha', with: '654321'
          fill_in 'Confirmação de senha', with: '654321'
          click_on 'Cadastrar'
        end
    
        expect(page).to have_content('E-mail já está em uso')
        expect(page).not_to have_content('Bem vindo! Você realizou seu registro com sucesso')
        expect(page).not_to have_content('rco@gmail.com')
        expect(page).not_to have_content('Sair')
      
      end
end