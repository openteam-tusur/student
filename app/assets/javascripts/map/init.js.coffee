@init_map = ->

  $.getScript '//api-maps.yandex.ru/2.1/?lang=ru_RU', ->
    ymaps.ready ->

      # disable links to places in xs resolution and hide map
      if $("#js-contacts-map:visible").length == 0
        $("a.target.info").click (e) ->
          e.preventDefault()

        return

      # Initialization yandex map
      map = new ymaps.Map('js-contacts-map',
        center: [$('a.target.info:first').attr('data-x'), $('a.target.info:first').attr('data-y')]
        #center: [55.76, 37.64]
        zoom: 14
        behaviors: ['drag', 'scrollZoom']
        maxZoom: 23
        controls: ['fullscreenControl']
        minZoom: 3
        maxAnimationZoomDifference: 5

      )

     #enterFullscreen

      # set default ballon
      open_balloon = (x,y, content) ->
        map.balloon.open [x,y],
        {
          content: content
        },
          closeButton: true
          minWidth: 200
          minHeight: 200
          autoPan: true
          left: 0

      # set placemark
      set_placemark = (x,y, contentBalloon) ->
        placemark = new ymaps.Placemark(
          [x,y],
          {
            balloonContent: contentBalloon
          },
          iconLayout: 'default#image'
          iconImageSize: [35, 50]
          iconImageOffset: [-17, -50]
          iconImageHref: '/assets/placemark.png'
        )

        map.geoObjects.add placemark

      # function for display all placemarks on map
      placemarks_data = {}
      display_all_placemarks = ->
        $("a.target.info").each (index, target) ->
          x =  $(target).attr("data-x")
          y =  $(target).attr("data-y")
          balloonContent = "<div class='col-xs-12 location-box map-box'> #{$(target).closest('div.location-box').html()}</div>"
          set_placemark(x, y, balloonContent)
          placemarks_data["#{x}, #{y}"] = balloonContent

          return placemarks_data

      # on click to target, move to eny place
      $(".target").click (e) ->
        e.preventDefault()
        $.scrollTo('.info-box', 500, { offset: -60 })

        x = $(this).attr("data-x")
        y = $(this).attr("data-y")

        map.panTo([parseFloat(x), parseFloat(y)], safe: false, flying: false, duration: 1000, delay: 1000 ).then ->
          content = placemarks_data["#{x}, #{y}"]
          open_balloon(x,y,content)

      display_all_placemarks()

      # open default balloon
      def_x = $("a.main-corp").attr("data-x")
      def_y = $("a.main-corp").attr("data-y")
      def_content = placemarks_data["#{def_x}, #{def_y}"]

      open_balloon(def_x, def_y, def_content)

    return

  return
