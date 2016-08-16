@init_jcarousel_slider = ->
    default_arrow = 'https://storage.tusur.ru/files/17313/20-35/arrow.png'
    active_arrow  = 'https://storage.tusur.ru/files/17312/active-arrow.png'

    list_of_images = $('.js-simple-jcarousel')
    list_of_images.wrap('<div class="jcarousel_wrapper"></div>')
    list_of_images.wrap('<div class="jcarousel"></div>')
    $('.jcarousel_wrapper').prepend('<div class="left-arrow"></div>')
    $('.jcarousel_wrapper').append('<div class="right-arrow"></div>')
    $('.jcarousel_wrapper').find('.left-arrow').prepend("<a class='jcarousel-prev' href='#'><img class='img_left' src=#{default_arrow} ></a>")
    $('.jcarousel_wrapper').find('.right-arrow').append("<a class='jcarousel-next' href='#'><img class='img_right' src=#{default_arrow} ></a>")
    $('.js-simple-jcarousel').find('li').each (index, element) ->
      image = $(element).find('img')
      image.addClass('img-responsive')
      image.removeAttr('height').removeAttr('width')
      preview_image_src = image.attr('src').replace(/\d*-\d*/, '250-170!mn')
      image.wrap("<a href='#{image.attr('src')}' class='colorbox'></a>")
      image.attr('src', preview_image_src)

    $('.jcarousel').jcarousel {}
    $('.jcarousel-prev').jcarouselControl
      target: '-=1'
    $('.jcarousel-next').jcarouselControl
      target: '+=1'

    $('.img_left').mouseover ->
      $(this).attr('src', active_arrow)
    $('.img_left').mouseout ->
      $(this).attr('src', default_arrow)
    $('.img_right').mouseover ->
      $(this).attr('src', active_arrow)
    $('.img_right').mouseout ->
      $(this).attr('src', default_arrow)
    return

