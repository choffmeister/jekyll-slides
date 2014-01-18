class Slide
  constructor: (@chapter, element, @x, @y) ->
    @element = $(element)
    @element
      .css({
        "opacity": 0
        "position": "absolute"
        "max-width": "#{@chapter.slidez.originalWidth}px"
        "left": "50%"
        "top": "50%"
      })
      .css({
        "overflow": "visible"
        "width": "#{$(@element).width() + 4}px"
        "height": "#{$(@element).height() + 4}px"
        "margin-left": "#{-($(@element).width() + 4) / 2.0}px"
        "margin-top": "#{-($(@element).height() + 4) / 2.0}px"
      })

    @shift = 750
    @moveOutDown(true)

  moveIn: (immediate) => @css({ opacity: 1, x: 0, y: 0 }, immediate)
  moveOutLeft: (immediate) => @css({ opacity: 0, x: -@shift, y: 0 }, immediate)
  moveOutRight: (immediate) => @css({ opacity: 0, x: @shift, y: 0 }, immediate)
  moveOutUp: (immediate) => @css({ opacity: 0, x: 0, y: -@shift }, immediate)
  moveOutDown: (immediate) => @css({ opacity: 0, x: 0, y: @shift }, immediate)

  css: (style, immediate) =>
    if immediate == true
      @element.css(style)
    else
      @element.transition(style, 1000, "ease")
    this

class Chapter
  constructor: (@slidez, element, @x) ->
    @element = $(element)
    @slides = _.map(@element.children(".slide"), (s, i) => new Slide(this, s, x, i))

class Slidez
  constructor: (originalWidth, originalHeight) ->
    @originalWidth = originalWidth or 1024
    @originalHeight = originalHeight or 768
    @ration = @originalWidth / @originalHeight

    $(window).resize (event) => @resize(event)
    $(window).keydown (event) => @keydown(event)

  init: () =>
    @chapters = _.map($("#slidez .chapter"), (c, i) => new Chapter(this, c, i))
    @i = 0

  start: () =>
    @chapters[0].slides[0].moveIn(true)

  resize: (event) =>

  keydown: (event) =>
    switch event.keyCode
      when 37 then @slideLeft()
      when 38 then @slideUp()
      when 39 then @slideRight()
      when 40 then @slideDown()

  slide: (chapterIndex, moveIndex) =>
    @chapters[chapterIndex].slides[moveIndex]

  slideUp: () =>
    @chapters[0].slides[@i].moveOutDown()
    @chapters[0].slides[--@i].moveIn()

  slideDown: () =>
    @chapters[0].slides[@i].moveOutUp()
    @chapters[0].slides[++@i].moveIn()

  slideLeft: () =>

  slideRight: () =>

window.slidez = new Slidez()
