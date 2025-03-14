class Asset < ApplicationRecord
  belongs_to :site

  has_one_attached :file
end
