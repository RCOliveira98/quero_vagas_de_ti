class Requirement < ApplicationRecord
    has_many :job_requirements
    has_many :jobs, through: :job_requirements
end
