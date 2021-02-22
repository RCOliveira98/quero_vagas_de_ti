class Candidate < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :candidate_profile
  accepts_nested_attributes_for :candidate_profile
  has_many :applications

  def profile?
    candidate_profile ? true : false
  end

  def build_profile
    unless profile?
      build_candidate_profile
    end
  end

end
