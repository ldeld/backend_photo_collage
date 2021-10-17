class ResizeImageService
  def initialize(image, dimension_to_resize, size_to_fit, options = {})
    @image = image
    @dimension_to_resize = dimension_to_resize
    @size_to_fit = size_to_fit
    @options = options
  end

  def run
    ratio_to_resize = (@size_to_fit.to_f / @image.send(@dimension_to_resize)) * 100
    @image.combine_options do |i|
      i.resize("#{ratio_to_resize}%")
      i.bordercolor("##{@options[:border_color]}")
      i.border(@options[:border_size])
    end

    @image
  end
end
