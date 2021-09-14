class Collage < ApplicationRecord
  has_one_attached :final_image

  has_many :collage_elements
  accepts_nested_attributes_for :collage_elements, allow_destroy: true

  validates_inclusion_of :orientation, in: %w( horizontal vertical ), on: :create, message: "%s is not a valid orientation"
end
