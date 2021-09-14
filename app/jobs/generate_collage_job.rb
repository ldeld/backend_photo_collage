class GenerateCollageJob < ApplicationJob
  queue_as :default

  def perform(collage)
    images = collage.collage_elements
  end
end
