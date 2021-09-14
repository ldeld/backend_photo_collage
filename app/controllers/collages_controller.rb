class CollagesController < ApplicationController
  def create
    collage = Collage.new(collage_params)
    if collage.save
      GenerateCollageJob.perform_later(collage)
      render collage
    else
      render collage.errors
    end
  end

  private

  def collage_params
    params.require(:collage).permit(:border_size, :border_color, :orientation, collage_elements_attributes: [:image])
  end
end
