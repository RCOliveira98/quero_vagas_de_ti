class Application < ApplicationRecord
  belongs_to :job
  belongs_to :candidate
  has_one :decline_application
  has_one :proposal

  def pending_evaluation?
    decline_application || proposal ? false : true
  end
end
