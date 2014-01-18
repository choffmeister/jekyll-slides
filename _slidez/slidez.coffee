class Slidez
  constructor: (originalWidth, originalHeight) ->
    @originalWidth = originalWidth or 1024
    @originalHeight = originalHeight or 768
    @ration = @originalWidth / @originalHeight

    $(window).resize (event) => @resize(event)
    $(window).keydown (event) => @keydown(event)

  init: () =>
    @x = 0
    @y = 0

    chapterIndex = -1
    slideIndex = -1

    @chapters = _.map($("#slidez .chapter"), (c) =>
      chapterIndex += 1
      chapterSlideIndex = -1

      index: chapterIndex
      container: c
      slides: _.map($(c).children(".slide"), (s) =>
        slideIndex += 1
        chapterSlideIndex += 1

        $(s)
          .css({
            "opacity": 0
            "position": "absolute"
            "max-width": "#{@originalWidth}px"
            "left": "50%"
            "top": "50%"
          })
          .css({
            "overflow": "visible"
            "width": "#{$(s).width() + 4}px"
            "height": "#{$(s).height() + 4}px"
            "margin-left": "#{-($(s).width() + 4) / 2.0}px"
            "margin-top": "#{-($(s).height() + 4) / 2.0}px"
            "x": -300
          })
          .transition({
            "opacity": 1
            "x": 0
            "duration": 5000
          })

        index: slideIndex
        indexInChapter: chapterSlideIndex
        container: s
      )
    )
    console.log(@chapters)

  start: () =>

  resize: (event) =>

  keydown: (event) =>
    switch event.keyCode
      when 37 then @slideLeft()
      when 38 then @slideUp()
      when 39 then @slideRight()
      when 40 then @slidslideDowneLeft()

  slide: (chapterIndex, slideIndex) =>
    @chapters[chapterIndex].slides[slideIndex]

  slideUp: () =>

  slideDown: () =>

  slideLeft: () =>

  slideRight: () =>

window.slidez = new Slidez()
