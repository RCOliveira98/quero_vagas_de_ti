class Company < ApplicationRecord
    validates :email_suffix, presence: true
    has_many :employees
    has_one_attached :logo

    def self.find_or_create(email_suffix)
        email_suffix.downcase!
        company = Company.find_by(email_suffix: email_suffix)
        
        unless company
            company = Company.create(email_suffix: email_suffix)
        end

        company
    end
    
end
