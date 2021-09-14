class CollageElement < ApplicationRecord
  belongs_to :collage
  has_one_attached :image
end
