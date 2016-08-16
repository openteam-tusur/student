@init_mobile_right_navigation = ->

  button = $('.js-toggle-button')
  menu = button.closest('.right-navigation')
  menu_top_position = menu.position().top
  menu_top_offset = 15

  menu.removeClass('opened').removeClass('closed')
  opened_left_position = 0
  closed_left_position = menu.width()
  menu.addClass('closed')

  turn_menu_to_left = ->
    menu.animate
      left: opened_left_position
    , 200, ->
      menu.removeClass('closed').addClass('opened')
      return
    return

  turn_menu_to_right = ->
    menu.animate
      left: closed_left_position
    , 200, ->
      menu.removeClass('opened').addClass('closed')
      return
    return

  button.click ->
    if menu.hasClass('closed')
      turn_menu_to_left()
    else
      turn_menu_to_right()
    return

  $(window).scroll ->
    #button.click() if menu.hasClass('opened')
    if menu_top_position - $(this).scrollTop() > menu_top_offset
      menu.css('top', menu_top_position - $(this).scrollTop())
    else
      menu.css('top', menu_top_offset)
    return

  $(window).resize ->
    closed_left_position = menu.width()
    menu.css('left', closed_left_position) if menu.hasClass('closed')
    return

  $(menu).swipe
    excludedElements: 'select, textarea'
    swipeLeft: (event, direction, distance, duration, fingerCount, fingerData, currentDirection) ->
      turn_menu_to_left()
      return
    swipeRight: (event, direction, distance, duration, fingerCount, fingerData, currentDirection ) ->
      turn_menu_to_right()
      return

  return
