class Job < ApplicationRecord
  belongs_to :company
  belongs_to :employee

  has_many :job_requirements
  has_many :requirements, through: :job_requirements
  has_many :applications

  enum level: {junior: 10, pleno: 20, senior: 30}

  validates :title, :description, :level, :lowest_salary, :highest_salary, :quantity, :deadline_for_registration, presence: true

  def self.select_unexpired_jobs_for_a_company(company_id)
    Job.includes(:company).where(
      "company_id = ? AND deadline_for_registration >= ?", company_id, Time.now
    )
  end

  def creator_of_the_same_company?(company_aux_id)
    company_id == company_aux_id
  end
end
