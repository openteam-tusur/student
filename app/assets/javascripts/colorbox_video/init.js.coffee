@init_colorbox_video = ->
  window_width = 0

  $(window).resize ->
    window_width = $(window).width()

  $(window).resize()

  if $('.js_video').length
    $('.js_video').each ->
      $('.video_preview').append('<span class="glyphicon glyphicon-play-circle"></span>')
      $(this)
        .removeClass('js_video')
        .addClass('js-colorbox-video')
        .attr('data-video', $(this).attr('data_video'))
        .removeAttr('data_video')

  $('.js-colorbox-video').each ->
    $(this).click ->
      title = $(this).text().compact() || $('img', $(this)).attr('alt')
      poster = $(this).attr('href')
      video = $(this).attr('data-video')
      timestamp = Math.floor(Date.now() / 1000)
      if window_width < 768 # xs
        width = 270
        height = 151
      else if window_width >= 768 && window_width < 992 # sm
        width = 450
        height = 253
      else if window_width >= 992 && window_width < 1200 # md
        width = 560
        height = 315
      else if window_width >= 1200
        width = 640
        height = 360

      flashvars = "auto=play&amp;st=/assets/video-640x360.txt&amp;poster=#{poster}&amp;file=#{video}&amp;comment=#{title}"

      if video.match(/\youtube.com/).length
        video = "#{video}?autoplay=1" unless video.match(/autoplay/)
        html = "<div class='colorbox-video'><iframe width='#{width}' height='#{height}' src='#{video}' frameborder='0' allowfullscreen></iframe></div>"

      if video.match(/\.flv$/)
        html = "<div class='colorbox-video'>\n" +
          "<object id='videoplayer#{timestamp}' width='#{width}' height='#{height}'>\n" +
          "<param name='bgcolor' value='#ffffff' />\n" +
          "<param name='allowFullScreen' value='true' />\n" +
          "<param name='allowScriptAccess' value='always' />\n" +
          "<param name='movie' value='/assets/player.swf' />\n" +
          "<param name='flashvars' value='#{flashvars}' />\n" +
          "<embed src='/assets/player.swf' name='videoplayer#{timestamp}' type='application/x-shockwave-flash' " +
          "allowscriptaccess='always' allowfullscreen='true' " +
          "flashvars='#{flashvars}' " +
          "bgcolor='#ffffff' width='#{width}' height='#{height}'></embed>\n" +
          "</object>\n" +
          "</div>"

      $.colorbox
        title: title
        html: html
        opacity: 0.5

      return false

    return


  return

