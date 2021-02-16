class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company
  has_one :company_admin

  def admin?
    CompanyAdmin.find_by(employee: id)
  end

  def admin_company_id
    company_admin&.company_id
  end
end
