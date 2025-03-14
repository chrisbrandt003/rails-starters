class Site < ApplicationRecord
  has_many :assets, dependent: :destroy
end
