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
    @arrange()

    # animation is blocked until the inital arrangement has been done
    window.setTimeout((() => @element.addClass("animated")), 0)

  arrange: () =>
    currentSlide = @currentChapter().currentSlide()

    _.each(@chapters,(c) =>
      _.each(c.slides, (s) =>
        switch s == currentSlide
          when true then Slide.setStateCss(s.element, "active")
          when false then Slide.setStateCss(s.element, "inactive")

        $(s.element).css({
          "-webkit-transform": "translate(#{(s.x - @currentChapter().x) * (@originalWidth + 20)}px, #{(s.y - c.currentSlide().y) * (@originalHeight + 20)}px)"
          "-moz-transform": "translate(#{(s.x - @currentChapter().x) * (@originalWidth + 20)}px, #{(s.y - c.currentSlide().y) * (@originalHeight + 20)}px)"
          "-ms-transform": "translate(#{(s.x - @currentChapter().x) * (@originalWidth + 20)}px, #{(s.y - c.currentSlide().y) * (@originalHeight + 20)}px)"
          "-o-transform": "translate(#{(s.x - @currentChapter().x) * (@originalWidth + 20)}px, #{(s.y - c.currentSlide().y) * (@originalHeight + 20)}px)"
          "transform": "translate(#{(s.x - @currentChapter().x) * (@originalWidth + 20)}px, #{(s.y - c.currentSlide().y) * (@originalHeight + 20)}px)"
        })
      )
    )

  resize: (event) =>

  keydown: (event) =>
    console.log(event.keyCode)
    switch event.keyCode
      when 27 # escape
        @element.toggleClass("overview")
      when 37 # left
        curr = @currentChapter()
        next = @previousChapter()
        if next?
          @current = next
          @arrange()
      when 39 # right
        curr = @currentChapter()
        next = @nextChapter()
        if next?
          @current = next
          @arrange()
      when 38 # up
        curr = @currentChapter().currentSlide()
        next = @currentChapter().previousSlide()
        if next?
          @currentChapter().current = next
          @arrange()
      when 40 # down
        curr = @currentChapter().currentSlide()
        next = @currentChapter().nextSlide()
        if next?
          @currentChapter().current = next
          @arrange()

window.Presentation = Presentation