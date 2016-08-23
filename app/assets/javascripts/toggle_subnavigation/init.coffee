@subnavigation_ul = null

@init_toggle_subnavigation = ->
  $('.js-init-subnanigation').mouseenter ->
    @subnavigation_ul = $(this).find('.js-subnavigation-item')

    return if @subnavigation_ul.data('open') == 'true'

    $(@subnavigation_ul).stop(true, false).slideDown('medium')
    @subnavigation_ul.attr('data-open', 'true')

  .mouseleave ->
    return if @subnavigation_ul.data('open') == 'false'

    $(@subnavigation_ul).stop(true, false).slideUp('fast')
    @subnavigation_ul.attr('data-open', 'false')
