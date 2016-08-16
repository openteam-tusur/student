@init_youtube_iframe = ->

  tags_with_link_to_video = $("p:contains('youtube.com'), p:contains('youtu.be')")

  return unless tags_with_link_to_video.length

  youtube_parser = (url) ->
    regExp = /^.*(youtu\.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/
    match = url.match(regExp)
    return match[2] if match && match[2].length == 11
    return false

  tags_with_link_to_video.each (index, item) ->
    link_to_video = $(this).text().compact()
    video_id = youtube_parser(link_to_video)
    $(this).html($('<iframe>', {
      id: "player-#{index}"
      class: 'youtube-video'
      type: 'text/html'
      width: '640'
      height: '360'
      frameborder: '0'
      allowfullscreen: ''
      src: "//www.youtube.com/embed/#{video_id}"
    })) if video_id
    return
  return

  return
