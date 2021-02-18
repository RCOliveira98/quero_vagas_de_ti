class Job < ApplicationRecord
  belongs_to :company
  belongs_to :employee

  has_many :job_requirements
  has_many :requirements, through: :job_requirements

  enum level: {junior: 10, pleno: 20, senior: 30}

  validates :title, :description, :level, :lowest_salary, :highest_salary, :quantity, :deadline_for_registration, presence: true
end
