@init_white_galleria = ->

  list_of_images = $('.js-simple-white-galleria')
  height_of_gallery = parseInt(list_of_images.attr('height'))
  height_of_gallery = 600 unless height_of_gallery
  crop_method = list_of_images.attr('crop')
  crop_method = 'width' unless crop_method

  list_of_images.find('li').each (index, element) ->
    image = $(element).find('img')
    src = image.attr('src')
    preview_image_src = src.replace(/\d*-\d*/, '100-100!mn')
    image.attr('src', preview_image_src)
    image.wrap("<a href='#{src}'></a>")

  list_of_images.wrap('<div class="white-galleria js-white-galleria galleria"></div>')
  list_of_images.wrap('<div class="photoalbum_wrapper"></div>')

  Galleria.loadTheme('/assets/galleria/themes/classic/galleria.classic.js')

  $('.js-white-galleria').galleria
    height: height_of_gallery
    imageCrop: crop_method
    thumbCrop: true
    showCounter: false
    showInfo: true
    swipe: true
    easing: 'galleriaIn'
    transition: 'fade'
    transitionInitial: 'fade'
    imagePosition: 'bottom'
    responsive: true
    trueFullscreen: true

  Galleria.ready ->
    galleria = this
    galleria_object = $('.js-white-galleria')
    galleria_object.addClass('hidden-elements')
    $('.js-white-galleria .galleria-stage').append("<span class='glyphicon glyphicon-fullscreen js-fullscreen'></span>")
    $('.js-white-galleria').find(".galleria-info-link").addClass("glyphicon glyphicon-info-sign")

    hidden_elements = undefined
    galleria.bind 'image', (e) ->
      if galleria_object.find('.galleria-info-description').is(':empty')
        hidden_elements = true
      else
        hidden_elements = false

    galleria_object.mouseenter ->
      $('.galleria-info').show() unless hidden_elements
      $('.galleria-info-link').show() and $('.galleria-info-link').show() unless hidden_elements
      $('.galleria-image-nav').show()
      $('.galleria-counter').show()
      $('.js-fullscreen').show()

    galleria_object.mouseleave ->
      $('.galleria-info').hide()
      $('.galleria-info-link').hide()
      $('.galleria-image-nav').hide()
      $('.galleria-counter').hide()
      $('.js-fullscreen').hide()

    counter = 0
    $('.js-white-galleria .js-fullscreen').click ->
      counter += 1
      $('.js-white-galleria').data('galleria').toggleFullscreen(
        if (counter % 2 != 0)
          galleria._options.maxScaleRatio = 1
          galleria._options.imagePosition = 'center center'
          galleria._options.thumbCrop = true
          galleria_object.find(".galleria-info").addClass("fullscreen")
        else
          galleria._options.imageCrop = 'landscape'
          galleria._options.imagePosition = 'center center'
          galleria._options.maxScaleRatio = undefined
          galleria_object.find(".galleria-info").removeClass("fullscreen")
      )

    $(document).keyup (e) ->
      if e.keyCode == 27
        galleria._options.imageCrop = 'landscape'
        galleria._options.imagePosition = 'center center'
        galleria._options.maxScaleRatio = undefined
        galleria_object.find(".galleria-info").removeClass("fullscreen")
        counter = 0


    thumbnail_wrapper = $('.js-white-galleria .galleria-thumbnails')
    thumbnails_count = $('.galleria-image', thumbnail_wrapper).length

    return

  return
