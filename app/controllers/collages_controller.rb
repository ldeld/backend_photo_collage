class CollagesController < ApplicationController
  def create
    collage = Collage.new(collage_params)
    if collage.save
      GenerateCollageWorker.perform_async(collage.id)
      render json: collage
    else
      renders json: collage.errors
    end
  end

  def status
    collage = Collage.find_by_id(params[:collage_id])
    render(status: :not_found) && return if collage.nil?

    if collage.final_image.attached?
      render json: { url: collage.final_image.url }
    else
      # retun 202 code (accepted but not done processing)
      render status: :accepted
    end
  end

  private

  def collage_params
    params.require(:collage).permit(:border_size, :border_color, :orientation, collage_elements_attributes: [:image])
  end
end
