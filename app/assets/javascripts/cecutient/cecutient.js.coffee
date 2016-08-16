(($) ->

  $.fn.cecutient = (options) ->

    options = options or {}
    options.debug = options.debug or false
    options.panel = $(options.panel)
    options.panel = $('.cecutient-panel') unless options.panel.length
    options.minimum_font_size = options.minimum_font_size or 14
    options.maximum_font_size = options.maximum_font_size or 26
    options.font_size_increment = options.font_size_increment or 2

    context = $(this)
    body = $('body')
    font_size_info = $('.font-size', options.panel)

    cecutient_remove_font_size_classes = ->
      for size in [options.minimum_font_size..options.maximum_font_size]
        body.removeClass "font-size-#{size}"
      return

    cecutient_remove_color_classes = ->
      for color in ['white', 'black', 'blue']
        body.removeClass "color-#{color}"
      return

    cecutient_remove_images_classes = ->
      for mode in ['show', 'hide']
        body.removeClass "images-#{mode}"
      return

    cecutient_on = ->
      console.log 'Cecutient: mode on' if options.debug

      Cookies.set 'cecutient', 'true' unless Cookies.get 'cecutient'
      body.addClass 'cecutient' if Cookies.get 'cecutient'

      Cookies.set 'cecutient_font_size', "font-size-#{options.minimum_font_size}" unless Cookies.get 'cecutient_font_size'
      body.addClass Cookies.get 'cecutient_font_size'
      font_size_info.text(Cookies.get('cecutient_font_size').replace('font-size-', ''))

      Cookies.set 'cecutient_color', 'color-white' unless Cookies.get 'cecutient_color'
      body.addClass Cookies.get 'cecutient_color'
      $(".#{Cookies.get('cecutient_color')}", options.panel).addClass('current')

      Cookies.set 'cecutient_images', 'images-show' unless Cookies.get 'cecutient_images'
      body.addClass Cookies.get 'cecutient_images'
      $(".#{Cookies.get('cecutient_images')}", options.panel).addClass('current')

      context.text(context.data('normal'))

      return

    cecutient_off = ->
      console.log 'Cecutient: mode off' if options.debug

      Cookies.remove 'cecutient'
      Cookies.remove 'cecutient_font_size'
      Cookies.remove 'cecutient_color'
      Cookies.remove 'cecutient_images'

      body.removeClass 'cecutient'
      cecutient_remove_font_size_classes()
      cecutient_remove_color_classes()
      cecutient_remove_images_classes()
      $('a.current', options.panel).removeClass('current')

      context.text(context.data('cecutient'))

      return

    cecutient_reduce_font_size = ->
      current_size = parseInt(Cookies.get('cecutient_font_size').replace('font-size-', ''))
      target_size = current_size - options.font_size_increment
      return if target_size < options.minimum_font_size
      target_size = "font-size-#{target_size}"
      console.log "Cecutient: reduce font-size to #{target_size}" if options.debug
      cecutient_remove_font_size_classes()
      Cookies.set 'cecutient_font_size', target_size
      body.addClass Cookies.get 'cecutient_font_size'
      font_size_info.text(Cookies.get('cecutient_font_size').replace('font-size-', ''))
      return

    cecutient_incrase_font_size = ->
      current_size = parseInt(Cookies.get('cecutient_font_size').replace('font-size-', ''))
      target_size = current_size + options.font_size_increment
      return if target_size > options.maximum_font_size
      target_size = "font-size-#{target_size}"
      console.log "Cecutient: reduce font-size to #{target_size}" if options.debug
      cecutient_remove_font_size_classes()
      Cookies.set 'cecutient_font_size', target_size
      body.addClass Cookies.get 'cecutient_font_size'
      font_size_info.text(Cookies.get('cecutient_font_size').replace('font-size-', ''))
      return

    cecutient_set_color_scheme = (color) ->
      return if Cookies.get('cecutient_color') == color
      console.log "Cecutient: switch to #{color}" if options.debug
      cecutient_remove_color_classes()
      Cookies.set 'cecutient_color', color
      body.addClass Cookies.get 'cecutient_color'
      $(".#{Cookies.get('cecutient_color')}", options.panel).addClass('current').siblings().removeClass('current')
      return

    cecutient_images_on = ->
      return if Cookies.get('cecutient_images') == 'images-show'
      console.log 'Cecutient: switch images on' if options.debug
      cecutient_remove_images_classes()
      Cookies.set 'cecutient_images', 'images-show'
      body.addClass Cookies.get 'cecutient_images'
      $(".#{Cookies.get('cecutient_images')}", options.panel).addClass('current').siblings().removeClass('current')
      return

    cecutient_images_off = ->
      return if Cookies.get('cecutient_images') == 'images-hide'
      console.log 'Cecutient: switch images off' if options.debug
      cecutient_remove_images_classes()
      Cookies.set 'cecutient_images', 'images-hide'
      body.addClass Cookies.get 'cecutient_images'
      $(".#{Cookies.get('cecutient_images')}", options.panel).addClass('current').siblings().removeClass('current')
      return

    # bind events

    context.unbind('click').bind 'click', ->
      if Cookies.get('cecutient') == 'true'
        cecutient_off()
      else
        cecutient_on()
      return false

    $('.reduce-font-size', options.panel).unbind('click').bind 'click', ->
      cecutient_reduce_font_size()
      return false

    $('.increase-font-size', options.panel).unbind('click').bind 'click', ->
      cecutient_incrase_font_size()
      return false

    $('.setting-color a', options.panel).unbind('click').bind 'click', ->
      color = $(this).attr('class')
      cecutient_set_color_scheme (color)
      return false

    $('.images-show', options.panel).unbind('click').bind 'click', ->
      cecutient_images_on()
      return false

    $('.images-hide', options.panel).unbind('click').bind 'click', ->
      cecutient_images_off()
      return false

    cecutient_on() if Cookies.get('cecutient')

  return
) jQuery
