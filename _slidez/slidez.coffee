class Slidez
  init: () =>
    chapterIndex = -1
    slideIndex = -1

    @chapters = _.map($("#slidez .chapter"), (c) ->
      chapterIndex += 1
      chapterSlideIndex = -1

      slides: _.map($(c).children(".slide"), (s) ->
        slideIndex += 1
        chapterSlideIndex += 1

        $(s).css({
          "position": "absolute"
          "left": "#{chapterIndex * 300}px"
          "width": "#{300}px"
          "top": "#{chapterSlideIndex * 300}px"
          "height": "#{300}px"
        })

        s
      )
    )
    console.log(@chapters)

  start: () =>

window.slidez = new Slidez()
