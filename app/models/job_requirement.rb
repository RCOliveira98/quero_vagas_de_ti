class JobRequirement < ApplicationRecord
  belongs_to :job
  belongs_to :requirement
end
