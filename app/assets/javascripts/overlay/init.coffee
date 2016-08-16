@init_overlay = ->

  $('.js-init-overlay').mouseenter ->
    offset_top = $('.js-main-navigation').offset().top
    height = $(document).height() - offset_top

    $('.js-overlay').css
      top: offset_top
      height: height

    $('.js-overlay').show()

  .mouseleave ->
    $('.js-overlay').hide()

@init_image_menu = ->
  $('.js-image-menu').click ->
    $('.js-fullscreen-menu').toggle()
    init_body_overflow_toggle()

    return
  return

@init_fullscreen_menu_close = ->
  $(document).keyup (e) ->
    if e.keyCode == 27
      $('.js-fullscreen-menu').hide()
      init_body_overflow_toggle()

      return
    return

  $('.js-fullscreen-menu-close').click ->
    $('.js-fullscreen-menu').hide()
    init_body_overflow_toggle()

    false

  return

init_body_overflow_toggle = ->
  return
  if $('body').css('overflow') == 'hidden'
    $('body').css
      overflow: 'visible'
  else
    $('body').css
      overflow: 'hidden'

  return
