@init_mime = ->

  mime = [
    'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx',
    'rtf', 'ods', 'odt', 'rar', 'zip', 'csv'
  ]

  $('a').each (index, item) ->
    return if $(this).hasClass('icon')
    return unless $(this).attr('href')
    extention = $(this).attr('href').split('.').last().toLowerCase()
    $(this).addClass('icon').addClass(extention) if mime.indexOf(extention) >= 0
    return

  return
