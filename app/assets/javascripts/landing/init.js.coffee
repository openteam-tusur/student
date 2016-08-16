@init_landing = ->

  $('.navigation_images').nextAll().wrapAll($('<div>', { class: 'col-lg-9 col-md-9 col-sm-8 col-xs-12 left_side', role: 'main' }))
  $('<div>', { class: 'col-lg-3 col-md-3 col-sm-4 hidden-xs right_side', role: 'complementary' }).insertAfter($('.navigation_images').next('.left_side'))
  $('.navigation_images').nextAll().wrapAll($('<div>', { class: 'row landing_container' }))
  $('body').attr('data-spy': 'scroll', 'data-offset': '100')
  landing_container = $('.landing_container')

  affix_list = $('<ul>', { class: 'nav sidenav', role: 'tablist', width: $('.right_side', landing_container).width() }).appendTo($('.right_side', landing_container))

  $('.navigation_images .image a').each ->
    $('<li>', { html: $(this).clone() }).appendTo(affix_list)
    return

  switch $('html').attr('lang')
    when 'en' then back_to_top_text = 'Back to top'
    when 'ru' then back_to_top_text = 'Наверх'

  back_to_top_link = $('<a>', { class: 'back-to-top', href: '#back-to-top', text: back_to_top_text })
  $('<li>', { html: back_to_top_link }).appendTo(affix_list)

  init_affix = ->
    affix_offset_top = landing_container.position().top + 70
    affix_offset_bottom = $(document).height() - $('.inner-page-wrapper').position().top - $('.inner-page-wrapper').innerHeight() + 20
    affix_list.affix()
    affix_list.data('bs.affix').options.offset = { top: affix_offset_top, bottom: affix_offset_bottom }
    return

  setTimeout -> # fix wrong calculate offset after load page
    init_affix()
    return
  , 100

  $(window).resize ->
    init_affix()
    $(window).trigger('scroll')
    return

  # monkeypatch for affix bug: https://github.com/twbs/bootstrap/issues/15847
  $(window).on 'keyup', (e) ->
    # safari fires 63273 instead of 36 for home key
    (e.keyCode == 36 || e.keyCode == 63273) && $(window).trigger('scroll')
    # safari fires 63275 instead of 35 for end key
    (e.keyCode == 35 || e.keyCode == 63275) && $(window).trigger('scroll')
    return

  $('.navigation_images .image').each ->
    block = $(this)
    header = $('h4', block)
    abstract = $('p', block)

    if abstract.length
      animate_speed = 300
      header.css
        top: header.position().top
        bottom: 'auto'

      block.mouseenter ->
        header.stop(true, true).animate
          top: 0
        , animate_speed
        abstract.stop(true, true).animate
          top: header.innerHeight()
          bottom: 0
        , animate_speed
        return
      .mouseleave ->
        header.animate
          top: block.innerHeight() - header.innerHeight()
        , animate_speed
        abstract.animate
          top: '100%'
        , animate_speed
        return

  $('.navigation_images .image a, .landing_container .nav a').click (event) ->
    hash = $(this).attr('href')
    target = $(hash)
    if hash == '#back-to-top'
      hash = ' '
      target = $('html')
    yScroll = document.body.scrollTop
    window.location.hash = hash
    document.body.scrollTop = yScroll
    $.scrollTo(target, 500, {
      offset: { top: -70 }
    })
    return false

  return
