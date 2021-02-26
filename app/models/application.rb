class Application < ApplicationRecord
  belongs_to :job
  belongs_to :candidate
  has_one :decline_application

  def pending_evaluation?
    decline_application ? false : true
  end
end
