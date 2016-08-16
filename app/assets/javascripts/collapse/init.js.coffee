@init_collapse = ->
  for element in $(".collapsed-items-wrapper")
    link = $(element).find(".collapse-link")
    link.attr "data-toggle": "collapse"

  # auto wrapper for collapser div
  collapser = $(".js-simple-collapser")
  collapser.addClass("collapser")
  collapser.wrap("<div class='js-client-collapser'></div>")
  collapser.find("h5").wrap("<div class='list-header'></div>").wrapInner("<a class='js-collapse-link'></a>")
  content = collapser.find("div.collapser-content").addClass("collapse js-collapse-content").wrapInner("<div class='well'></div>")

  $(".js-client-collapser .collapser").each (index, element) ->
    link = $(element).find(".js-collapse-link")
    link.attr "data-toggle" : "collapse", "href" : "#collapseContent-#{index}", "aria-expanded" : "false", "aria-controls" : "collapseContent-#{index}"
    content = $(element).find(".js-collapse-content")
    content.attr "id" : "collapseContent-#{index}", "aria-expanded" : "false"


  if window.location.hash.length
    hash_data = "#{window.location.hash.slice(1)}"

    active_collapser = $("[id=#{hash_data}]")
    if active_collapser.length
      $('body').animate({scrollTop: active_collapser.position().top + 140}, 1000)
      active_collapser.find('.js-collapse-link').click()
