class Company < ApplicationRecord
    validates :email_sufix, presence: true
    has_many :employees

    def self.find_or_create(email_sufix)
        email_sufix.downcase!
        company = Company.find_by(email_sufix: email_sufix)
        
        unless company
            company = Company.create(email_sufix: email_sufix)
        end

        company
    end
end
