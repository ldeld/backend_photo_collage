class ResizeImageBatchService
  # Taks an array of MiniMagick::Image and resizes them to fit in a given orientation
  def initialize(images, options = nil)
    @images = images
    @options = options || { horizontal: true, border_size: 0, border_color: 'FFFFFF' }
  end


  def run
    calc_size_to_fit
    @images.map { |image| ResizeImageService.new(image, @dimension_to_resize, @size_to_fit, @options).run }
  end

  private

  def calc_size_to_fit
    @dimension_to_resize = @options[:horizontal] ? :height : :width
    @size_to_fit = @images.map { |image| image.send(@dimension_to_resize) }.min
  end
end