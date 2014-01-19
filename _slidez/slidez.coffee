class Slide
  content: () => @element.html().trim()

  constructor: (@chapter, element, @x, @y) ->
    @element = $(element)
    @element
      .css({
        "opacity": 0
        "position": "absolute"
        "left": "50%"
        "top": "50%"
      })
      .css({
        "max-width": "#{@chapter.slidez.originalWidth}px"
      })
      .css({
        "overflow": "visible"
        "width": "#{$(@element).width() + 4}px"
        "height": "#{$(@element).height() + 4}px"
        "margin-left": "#{-($(@element).width() + 4) / 2.0}px"
        "margin-top": "#{-($(@element).height() + 4) / 2.0}px"
      })

  moveIn: (immediate) => @css({ opacity: 1, x: 0, y: 0 }, immediate)
  moveOutLeft: (immediate) => @css({ opacity: 0, x: -1000, y: 0 }, immediate)
  moveOutRight: (immediate) => @css({ opacity: 0, x: 1000, y: 0 }, immediate)
  moveOutUp: (immediate) => @css({ opacity: 0, x: 0, y: -1000 }, immediate)
  moveOutDown: (immediate) => @css({ opacity: 0, x: 0, y: 1000 }, immediate)

  css: (style, immediate) =>
    if immediate == true
      @element.css(style)
    else
      @element.transition(style, 1000, "ease")
    this

class Chapter
  currentSlide: () => @current
  previousSlide: () => if @current.y > 0 then @slides[@current.y - 1] else undefined
  nextSlide: () => if @slides.length - 1 > @current.y then @slides[@current.y + 1] else undefined

  constructor: (@slidez, element, @x) ->
    @element = $(element)
    @slides = _.chain(@element.children(".slide"))
      .map((s, i) => new Slide(this, s, x, i))
      .filter((s) => s.content().length > 0)
      .value()
    @current = _.first(@slides)


class Slidez
  currentChapter: () => @current
  previousChapter: () => if @current.x > 0 then @chapters[@current.x - 1] else undefined
  nextChapter: () => if @chapters.length - 1 > @current.x then @chapters[@current.x + 1] else undefined

  constructor: (originalWidth, originalHeight) ->
    @originalWidth = originalWidth or 1024
    @originalHeight = originalHeight or 768
    @ration = @originalWidth / @originalHeight

    $(window).resize (event) => @resize(event)
    $(window).keydown (event) => @keydown(event)

  init: () =>
    @chapters = _.chain($("#slidez .chapter"))
      .map((c, i) => new Chapter(this, c, i))
      .filter((c) => c.slides.length > 0)
      .value()
    @current = _.first(@chapters)

    _.each(@chapters, (c) ->
      _.each(c.slides, (s) ->
        s.moveOutRight(true) unless s.x == 0
        s.moveOutDown(true) unless s.y == 0
      )
    )
    @currentChapter().currentSlide().moveIn(true)

  keydown: (event) =>
    switch event.keyCode
      when 37 # left
        curr = @currentChapter()
        next = @previousChapter()
        if next?
          curr.currentSlide().moveOutRight()
          next.currentSlide().moveIn()
          @current = next
      when 39 # right
        curr = @currentChapter()
        next = @nextChapter()
        if next?
          curr.currentSlide().moveOutLeft()
          next.currentSlide().moveIn()
          @current = next
      when 38 # up
        curr = @currentChapter().currentSlide()
        next = @currentChapter().previousSlide()
        if next?
          curr.moveOutDown()
          next.moveIn()
          @currentChapter().current = next
      when 40 # down
        curr = @currentChapter().currentSlide()
        next = @currentChapter().nextSlide()
        if next?
          curr.moveOutUp()
          next.moveIn()
          @currentChapter().current = next


window.slidez = new Slidez()
