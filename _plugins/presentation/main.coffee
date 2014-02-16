class Slide
  content: () => @element.html().trim()

  constructor: (@chapter, element, @x, @y) ->
    @element = $(element)
    @element
      .css({
        "position": "absolute"
        "left": "50%"
        "top": "50%"
        "overflow": "visible"
      })
      .css({
        "width": "#{@chapter.presentation.originalWidth}px"
        "margin-left": "#{-@chapter.presentation.originalWidth / 2.0}px"
      })
      .css({
        "height": "#{$(@element).height() + 4}px"
        "margin-top": "#{-($(@element).height() + 4) / 2.0}px"
      })

  moveIn: (immediate) => Slide.setStateCss(@element, "active")
  moveOutLeft: (immediate) => Slide.setStateCss(@element, "left")
  moveOutRight: (immediate) => Slide.setStateCss(@element, "right")
  moveOutUp: (immediate) => Slide.setStateCss(@element, "up")
  moveOutDown: (immediate) => Slide.setStateCss(@element, "down")

  @setStateCss: (element, state) =>
    Slide.cleanStateCss($(element)).addClass("state-#{state}")
    $(element)

  @cleanStateCss: (element) ->
    $(element).removeClass (index, css) ->
      (css.match(/state-[^\s]+/g) or []).join(" ")
    $(element)

class Chapter
  currentSlide: () => @current
  previousSlide: () => if @current.y > 0 then @slides[@current.y - 1] else undefined
  nextSlide: () => if @slides.length - 1 > @current.y then @slides[@current.y + 1] else undefined

  constructor: (@presentation, element, @x) ->
    @element = $(element)
    @slides = _.chain(@element.children(".slide"))
      .map((s, i) => new Slide(this, s, x, i))
      .filter((s) => s.content().length > 0)
      .value()
    @current = _.first(@slides)

class Presentation
  currentChapter: () => @current
  previousChapter: () => if @current.x > 0 then @chapters[@current.x - 1] else undefined
  nextChapter: () => if @chapters.length - 1 > @current.x then @chapters[@current.x + 1] else undefined

  constructor: (element, originalWidth, originalHeight) ->
    @element = $(element)
    @originalWidth = originalWidth or 800
    @originalHeight = originalHeight or 600
    @ratio = @originalWidth / @originalHeight

    $(window).keydown (event) => @keydown(event)
    $(window).resize (event) => @resize()
    @resize()

  init: () =>
    @chapters = _.chain(@element.children(".chapter"))
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

  resize: (event) =>

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

window.Presentation = Presentation
