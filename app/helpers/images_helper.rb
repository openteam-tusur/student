module ImagesHelper
  def has_images?(object)
    object.images.any?
  end
end
