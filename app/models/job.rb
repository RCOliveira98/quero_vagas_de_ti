class Job < ApplicationRecord
  belongs_to :company
  belongs_to :employee

  has_many :job_requirements
  has_many :requirements, through: :job_requirements
end
