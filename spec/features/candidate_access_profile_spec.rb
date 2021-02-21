require 'rails_helper'

feature 'candidate access profile' do

    scenario 'login required' do
        candidate = Candidate.create!(email: 'rco@gmail.com', password: '123456')
        visit candidates_backoffice_profile_path(candidate.id)
        expect(current_path).not_to eq candidates_backoffice_profile_path(candidate.id)
        expect(current_path).to eq new_candidate_session_path
    end
    
    scenario 'Success' do
        candidate = Candidate.create!(email: 'rco@gmail.com', password: '123456')
        CandidateProfile.create!(candidate: candidate, name: 'Romário', phone: '1232321323')
        candidate.reload

        login_as(candidate, scope: :candidate)

        visit candidates_backoffice_root_path
        click_on candidate.email

        expect(current_path).to eq(candidates_backoffice_profile_path(candidate.id))
        expect(page).to have_content('Perfil do candidato')
        expect(page).to have_content(candidate.candidate_profile.name)
        expect(page).to have_content(candidate.candidate_profile.phone)
        expect(page).to have_content(candidate.email)
    end
end