@init_google_gallery = ->

  if $(window).width() > 767
    gallery_wrapper = $('.js-google-gallery')

    clear_li_items = ->
      gallery_wrapper.find('li').each (index, element) ->
        $(element).removeClass('active_li active expander-li open').removeAttr('style')
        $(element).find('.thumbnail').removeClass('active-thumbnail')

    $('.item .thumbnail').click (e) ->
      e.preventDefault()
      active_li = $(this).closest('li.item')

      if active_li.hasClass('active_li')
        clear_li_items()
        active_li.find('.full-image-box').hide()
        return

      clear_li_items()
      active_li.addClass('active_li')
      active_li.find('.thumbnail').addClass('active-thumbnail')

      gallery_wrapper.find('.full-image-box').empty().hide()
      parent_li =  active_li.closest('li')
      parent_li.addClass('active')
      full_image_src = parent_li.find('a').attr('data-fullimg')
      parent_li.find('.full-image-box').append("<span class='preview'></span><img src='#{full_image_src}' class='full-image'><span class='next'></span>").fadeIn('slow')

      gallery_wrapper.find('li').each (index, element) ->
        if $(element).position().top == active_li.position().top
           $(element).addClass('expander-li')

      active_li.find('.full-image').load ->
        gallery_wrapper.find('.expander-li').css({"margin-bottom": "#{$(this).height() + 10}px"})

      $.scrollTo($(this), 500, {
        offset: { top: -10 }
      })

      gallery_wrapper.find('.expander-li').addClass('open')

      # Next photo click emulation, when mouse next button click
      emulation_next_photo_click = ->
        next_photo = active_li.next().find('.thumbnail')
        if next_photo.length
          next_photo.click()
        else
          $('.item:first .thumbnail').click()

      # Preview photo click emulation, when mouse preview button click
      emulation_prev_photo_click = ->
        preview_photo = active_li.prev().find('.thumbnail')
        if preview_photo.length
          preview_photo.click()
        else
          gallery_wrapper.find('.item:last .thumbnail').click()

      # Hover arrows navigation
      gallery_wrapper.find('.next, .preview').hover ->
        $(this).addClass('active')
      , ->
        $(this).removeClass('active')

      # Emulation click on next preview buttons
      gallery_wrapper.find('.next').click ->
        emulation_next_photo_click()

      gallery_wrapper.find('.preview').click ->
        emulation_prev_photo_click()


      # keypress emulation next preview
      $(document).keyup (event) ->
        if (event.which == 39)
          $(document).unbind('keyup')
          emulation_next_photo_click()

        if (event.which == 37)
          $(document).unbind('keyup')
          emulation_prev_photo_click()

        return

  else
    gallery_wrapper = $('.js-google-gallery')
    $('.item .thumbnail').click (e) ->
      e.preventDefault()

    gallery_wrapper.find('.item').each (index, element) ->
      big_image_src = $(element).find('a').attr('data-fullimg')
      $(element).find('.thumbnail').attr('src', big_image_src).removeAttr('width').removeAttr('height')
