class Company < ApplicationRecord
    validates :email_suffix, presence: true
    validates :name, presence: true, on: :update
    validates :cnpj, presence: true, on: :update

    has_many :employees
    has_many :jobs
    has_one_attached :avatar

    def self.find_or_create(email_suffix)
        email_suffix.downcase!
        company = Company.find_by(email_suffix: email_suffix)
        
        unless company
            company = Company.create(email_suffix: email_suffix)
        end

        company
    end

    def self.select_by_name(name)
        Company.where("name LIKE ?", "%#{name}%")
    end

    def select_jobs
        Job.where('deadline_for_registration >= ? AND company_id = ?', Time.now, id)
    end

    def select_jobs_by_title(title)
        Job.where('company_id = ? AND 
                title LIKE ? AND 
                deadline_for_registration >= ?', id, "%#{title}%", Time.now)
    end
    
end
