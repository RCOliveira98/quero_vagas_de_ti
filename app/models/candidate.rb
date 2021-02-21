class Candidate < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :candidate_profile

  def profile?
    candidate_profile ? true : false
  end

  def build_profile
    unless candidate_profile
      return CandidateProfile.new(candidate_id: id)
    end
    candidate_profile
  end

end
