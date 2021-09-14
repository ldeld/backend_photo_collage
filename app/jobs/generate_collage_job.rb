class GenerateCollageJob < ApplicationJob
  queue_as :default

  def perform(collage)
    @collage = collage
    @images = collage.collage_elements.map do |ce|
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
    width_to_fit = @images.min_by { |image| image.width }.width

    @images.each do |image|
      ratio_to_resize = (width_to_fit.to_f / image.width) * 100
      image.combine_options do |i|
        i.resize("#{ratio_to_resize}%")
        i.bordercolor("##{@collage.border_color}")
        i.border(@collage.border_size)
      end
    end
  end

  def join_images
    # Append @images together
    # convert image1 image2 -append result
    output_file_path = Rails.root.join('tmp/output.jpg')
    convert = MiniMagick::Tool::Convert.new
    @images.each do |image|
      convert << image.path
    end
    convert.append
    convert << output_file_path
    convert.call

    File.open(output_file_path)
  end
end
