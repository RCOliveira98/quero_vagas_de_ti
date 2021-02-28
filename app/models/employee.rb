class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, on: %i[update]

  belongs_to :company
  has_one :company_admin
  has_many :decline_applications
  has_many :proposals

  def admin?
    CompanyAdmin.find_by(employee: id)
  end

  def admin_company_id
    company_admin&.company_id
  end
end
