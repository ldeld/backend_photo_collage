class GenerateCollageWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform(collage_id)
    @collage = Collage.find(collage_id)

    images = open_collage_images
    resized_images = resize_images(images)
    final_image = join_images(resized_images)

    @collage.final_image.attach(io: final_image, filename: "collage.jpg")
    @collage.collage_elements.each { |ce| ce.image.purge }
  end

  private

  def open_collage_images
    @collage.collage_elements.map do |ce|
      MiniMagick::Image.open(ce.image.url)
    end
  end

  def resize_images(images)
    ResizeImageBatchService.new(
      images,
      horizontal: @collage.horizontal?,
      border_color: @collage.border_color,
      border_size: @collage.border_size).run
  end

  def join_images(images)
    final_image_output_file = "tmp/collage_#{@collage.id}.jpg"
    JoinImagesService.new(images, final_image_output_file, { horizontal: @collage.horizontal? }).run
  end
end
