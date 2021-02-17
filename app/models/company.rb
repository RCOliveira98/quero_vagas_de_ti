class Company < ApplicationRecord
    validates :email_suffix, presence: true
    validates :name, presence: true, on: :update
    validates :cnpj, presence: true, on: :update

    has_many :employees
    has_one_attached :avatar

    def self.find_or_create(email_suffix)
        email_suffix.downcase!
        company = Company.find_by(email_suffix: email_suffix)
        
        unless company
            company = Company.create(email_suffix: email_suffix)
        end

        company
    end
    
end
