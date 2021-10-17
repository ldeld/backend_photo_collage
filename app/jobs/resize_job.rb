class ResizeJob < ApplicationJob
  def perform(images, border_size = 0, border_color = 'FFFFFF', horizontal = true)
    @images = images
    @size = size
    @dimension_to_resize = horizontal ? :width : :height

    size_to_fit = @images.min_by { |image| image.send(dimension_to_resize) }.dimension_to_resize

    @images.each do |image|
      ratio_to_resize = (size_to_fit.to_f / image.send(dimension_to_resize)) * 100
      image.combine_options do |i|
        i.resize("#{ratio_to_resize}%")
        i.bordercolor("##{@collage.border_color}")
        i.border(@collage.border_size)
      end
    end
  end
end