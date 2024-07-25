class Genre < ApplicationRecord
  validates :for, inclusion: { in: %w[movie tv] }
end
