class GenerateCollageWorker
  include Sidekiq::Worker

  def perform(collage_id)
    @collage = Collage.find(collage_id)
    @images = @collage.collage_elements.map do |ce|
      MiniMagick::Image.open(ce.image.url)
    end

    resize_and_border_images
    final_image = join_images
    @collage.final_image.attach(io: final_image, filename: "collage.jpg")
    @collage.collage_elements.each { |ce| ce.image.purge }
  end

  private

  def resize_and_border_images
    # first implementation keeping it vertical
    # find narrowest images to fit others to it
    dimension_to_resize = @collage.horizontal? ? :height : :width

    size_to_fit = @images.map { |image| image.send(dimension_to_resize) }.min

    @images.each do |image|
      # TODO: turn this inot a small job and run concurrently
      ratio_to_resize = (size_to_fit.to_f / image.send(dimension_to_resize)) * 100
      image.combine_options do |i|
        i.resize("#{ratio_to_resize}%")
        i.bordercolor("##{@collage.border_color}")
        i.border(@collage.border_size)
      end
    end
  end

  def join_images
    # Append @images together
    # final command is: convert image1 image2 (-/+)append result
    output_file_path = Rails.root.join("tmp/collage_#{@collage.id}.jpg")
    convert = MiniMagick::Tool::Convert.new
    @images.each do |image|
      convert << image.path
    end
    convert_sign = @collage.horizontal? ? '+' : '-'
    # ImageMacick command: -append for vertical, +append for horizontal, see: https://stackoverflow.com/questions/20737061/merge-images-side-by-sidehorizontally/20749970
    convert << "#{convert_sign}append"
    convert << output_file_path
    convert.call

    File.open(output_file_path)
  end
end
