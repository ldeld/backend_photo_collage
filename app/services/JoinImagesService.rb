class JoinImagesService
  def initialize(images, output_filepath, options)
    @images = images
    @output_filepath = output_filepath
    @options = options || { horizontal: true }
  end

  def run
    # Append @images together
    # final command is: convert image1 image2 (-/+)append result
    convert = MiniMagick::Tool::Convert.new
    @images.each do |image|
      convert << image.path
    end
    convert_sign = @options[:horizontal] ? '+' : '-'
    # ImageMacick command: -append for vertical, +append for horizontal, see: https://stackoverflow.com/questions/20737061/merge-images-side-by-sidehorizontally/20749970
    convert << "#{convert_sign}append"
    convert << @output_filepath
    convert.call

    File.open(@output_filepath)
  end
end