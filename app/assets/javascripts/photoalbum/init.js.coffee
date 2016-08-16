@init_photo_album = ->

  Galleria.loadTheme('/assets/galleria/themes/classic/galleria.classic.js')

  $('.js-galleria').galleria
    #width: 848
    responsive: true
    imageCrop: 'width'
    thumbCrop: true
    swipe: true
    transitionSpeed: 500
    preload: 5
    showInfo: false
    easing: 'galleriaIn'
    showCounter: false
    transition: 'fade'
    transitionInitial: 'fade'
    idleMode: 'hover'
    idleTime: 1000

  Galleria.ready ->
    galleria = this

    $('.galleria-image-nav-right, .galleria-image-nav-left').addClass('visible-lg')

    $('.js-galleria').mouseenter ->
      $('.galleria-image-nav-right, .galleria-image-nav-left').css('opacity', '1')
    .mouseleave ->
      $('.galleria-image-nav-right, .galleria-image-nav-left').css('opacity', '.3')

    $('.js-galleria .galleria-images').append("<span class='glyphicon glyphicon-fullscreen js-fullscreen'></span>")

    $('.js-galleria .js-fullscreen').click ->
      $('.js-galleria').data('galleria').toggleFullscreen(
        $('.galleria-image:eq(0)').css({
          'width': '844px'
          'height': '431px'
        })
        $('.galleria-image:eq(0) img').css({
          'width': '620px'
          'height': '431px'
        })
      )

    thumbnail_wrapper = $('.js-galleria .galleria-thumbnails')
    thumbnails_count = $('.galleria-image', thumbnail_wrapper).length

    if $.fn.tinyscrollbar
      galleria.bind 'thumbnail', (e) ->
        if e.index + 1 == thumbnails_count
          thumbnail_wrapper.addClass('overview')
          thumbnail_wrapper.wrap($('<div>', { class: 'viewport' }))
          thumbnail_wrapper.closest('.viewport').wrap($('<div>', { class: 'tinyscrollbar' }))
          scrollbar = thumbnail_wrapper.closest('.tinyscrollbar')
          scrollbar.append(
            $('<div>', {
              class: 'scrollbar', html: $('<div>', {
                class: 'track', html: $('<div>', {
                  class: 'thumb', html: $('<div>', { class: 'end' })
                })
              })
            })
          )

          scrollbar.tinyscrollbar
            axis: 'x'

          scrollbar_observer = scrollbar.data('plugin_tinyscrollbar')
          Galleria.on 'image', (e) ->
            scrollbar_observer.update(Math.abs(thumbnail_wrapper.position().left))
            return

    return

  return
