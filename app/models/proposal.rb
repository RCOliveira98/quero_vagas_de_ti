class Proposal < ApplicationRecord
  belongs_to :application
  belongs_to :employee
end
