class Proposal < ApplicationRecord
  belongs_to :application
  belongs_to :employee

  validates :message, :start_date, :salary_proposal, presence: true
end
