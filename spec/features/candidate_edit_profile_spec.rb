require 'rails_helper'

feature 'candidate edit profile' do
    scenario 'login is required' do
        candidate = Candidate.create!(email: 'rco@gmail.com', password: '123456')

        visit edit_candidates_backoffice_candidate_path(candidate)
        expect(current_path).to eq new_candidate_session_path
    end

    scenario 'Success' do
        candidate = Candidate.create!(email: 'rco@gmail.com', password: '123456')
        login_as(candidate, scope: :candidate)

        visit edit_candidates_backoffice_candidate_path(candidate)
        expect(current_path).not_to eq new_candidate_session_path
        expect(page).to have_content('Editar perfil')

        find('form') do
            fill_in('E-mail', with: 'rco@gmail.com.br')
            fill_in('CPF', with: '11122233344')
            fill_in('Telefone', with: '89994102030')
            fill_in('Nome', with: 'Romário Coelho')
            click_on 'Atualizar'
        end

        expect(current_path).to eq candidates_backoffice_candidate_path(candidate)
        expect(page).to have_content('Perfil atualizado com sucesso')
    end

    scenario 'mandatory attributes cannot be blank' do
        candidate = Candidate.create!(email: 'rco@gmail.com', password: '123456')
        login_as(candidate, scope: :candidate)

        visit edit_candidates_backoffice_candidate_path(candidate)
        expect(current_path).not_to eq new_candidate_session_path
        expect(page).to have_content('Editar perfil')

        find('form') do
            fill_in('CPF', with: '')
            fill_in('Telefone', with: '')
            fill_in('Nome', with: '')
            click_on 'Atualizar'
        end

        expect(page).not_to have_content('Perfil atualizado com sucesso')
        expect(page).to have_content('CPF não pode ficar em branco')
        expect(page).to have_content('Telefone não pode ficar em branco')
        expect(page).to have_content('Nome não pode ficar em branco')
    end
end