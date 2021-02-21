class CandidateProfile < ApplicationRecord
  belongs_to :candidate
  validates :name, :cpf, :phone, presence: true
end
