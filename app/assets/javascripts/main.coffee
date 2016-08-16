$ ->

  init_white_galleria() if $('.js-white-galleria').length || $('.js-simple-white-galleria').length
  init_google_gallery() if $('.js-google-gallery').length
  init_jcarousel_slider() if $('.jcarousel').length || $('.js-simple-jcarousel').length
  init_colorbox() if $('a.colorbox').length
  init_colorbox_video() if $('.js-colorbox-video, .js_video').length
  init_tooltip() if $('.js-tooltip').length
  init_collapse() if $('.collapsed-items-wrapper').length || $('.js-client-collapser').length || $('.js-simple-collapser').length
  init_landing() if $('.navigation_images').length
  init_overlay() if $('.js-init-overlay').length
  init_photo_album() if $('.js-galleria').length
  init_map() if $('#js-contacts-map').length
  init_image_menu() if $('.js-image-menu').length
  init_fullscreen_menu_close() if $('.js-fullscreen-menu-close').length
  init_mobile_right_navigation() if $('.js-toggle-button').length
  init_youtube_iframe()
  init_mime()
  init_cetutient()

  $('a.disabled').click ->
    return false

  if window.location.hash.length
    setTimeout -> # fix wrong calculate offset after load page
      target = $(window.location.hash)
      return unless target.length
      document.body.scrollTop = 0
      $.scrollTo(target, 500, {
        offset: { top: -70 }
      })
      return
    , 100

  return


$(window).load ->
  # do something when window is loaded
  # add active-item class for current item in right navigation
  $('.right-navigation .active:last').addClass('active-item')

  return
