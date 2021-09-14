class CollagesController < ApplicationController
  def create
    binding.pry
    collage = Collage.new(collage_params)
    if collage.save
      GenerateCollageJob.perform_later(collage)
    else
      render :ok
    end
  end

  private

  def collage_params
    params.require(:collage).permit(:border_size, :border_color, :orientation, collage_elements_attributes: [:image])
  end
end
