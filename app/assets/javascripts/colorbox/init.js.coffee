@init_colorbox = ->

  $('a.colorbox:visible:not([rel=subdivision_gallery])').attr('rel', 'gallery')
  $('a.colorbox').colorbox
    close: 'закрыть'
    current: '{current} из {total}'
    maxHeight: '90%'
    maxWidth: '90%'
    next: 'следующая'
    opacity: '0.5'
    photo: true
    previous: 'предыдущая'
    returnFocus: false
    rel: ->
      $(this).data('rel') || $(this).attr('rel')
    title: ->
      $(this).attr('title') || $('img', this).attr('alt') || '&nbsp;'

  return
