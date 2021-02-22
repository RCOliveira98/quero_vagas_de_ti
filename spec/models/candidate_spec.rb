require 'rails_helper'

RSpec.describe Candidate, type: :model do
  describe '#profile?' do
    it 'return true' do
      candidate = Candidate.create!(email: 'rco@gmail.com.br', password: '123456')
      CandidateProfile.create!(candidate: candidate, name: 'Romário', phone: '89994100120', cpf: '11122233344')
      expect(candidate.profile?).to eq(true)
    end

    it 'return false' do
      candidate = Candidate.create!(email: 'rco@gmail.com.br', password: '123456')
      expect(candidate.profile?).to eq(false)
    end
  end

  describe '#build_profile' do
    it 'empty profile is created' do
      candidate = Candidate.create!(email: 'rco@gmail.com.br', password: '123456')
      expect(candidate.candidate_profile).to be_falsey
      candidate.build_profile

      expect(candidate.candidate_profile).to be_truthy
      expect(candidate.candidate_profile.candidate_id).to eq candidate.id
    end

    it 'existing profile is not overwritten' do
      candidate = Candidate.create!(email: 'rco@gmail.com.br', password: '123456')
      CandidateProfile.create!(candidate: candidate, name: 'Romário', phone: '89994100120', cpf: '11122233344')

      candidate.build_profile
      expect(candidate.candidate_profile.name).to eq 'Romário'
      expect(candidate.candidate_profile.candidate_id).to eq candidate.id
    end
  end
end
