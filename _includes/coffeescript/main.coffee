class Slide
  content: () => @element.html().trim()

  constructor: (@chapter, element, @x, @y) ->
    @element = $(element)
    @element
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

  init: () =>
    @chapters = _.chain(@element.children(".content").children(".chapter"))
      .map((c, i) => new Chapter(this, c, i))
      .filter((c) => c.slides.length > 0)
      .value()
    @current = _.first(@chapters)
    @update()

    # register event handler
    $(window).swipe { swipe: @swipe }
    $(window).keydown (event) => @keydown(event)
    $(window).resize (event) => @resize()
    @resize()

    # animation is blocked until the inital arrangement has been done
    window.setTimeout((() => @element.addClass("animated")), 0)

  update: () =>
    x = @currentChapter().x
    y = @currentChapter().currentSlide().y

    currentSlide = @currentChapter().currentSlide()
    _.each(@chapters,(c) =>
      Presentation.translate(c.element, (c.x - @currentChapter().x) * (@originalWidth + 20), 0)
      _.each(c.slides, (s) =>
        switch s == currentSlide
          when true then Slide.setStateCss(s.element, "active")
          when false then Slide.setStateCss(s.element, "inactive")
        Presentation.translate(s.element, 0, (s.y - c.currentSlide().y) * (@originalHeight + 20))
      )
    )

    index = @getSlideIndex()
    @element.children(".position").text("#{index.index + 1} / #{index.total}")

  getSlideIndex: (slide) =>
    if slide?
      x = @slide.x
      y = @slide.y
    else
      x = @currentChapter().x
      y = @currentChapter().currentSlide().y

    total: _.reduce(@chapters, ((sum, c) -> sum + c.slides.length), 0)
    index: _.chain(@chapters)
      .filter((c) -> c.x < x)
      .reduce(((sum, c) -> sum + c.slides.length), 0)
      .value() + y

  switchPreviousChapter: () =>
    curr = @currentChapter()
    next = @previousChapter()
    if next?
      @current = next
      @update()

  switchNextChapter: () =>
    curr = @currentChapter()
    next = @nextChapter()
    if next?
      @current = next
      @update()

  switchPreviousSlide: () =>
    curr = @currentChapter().currentSlide()
    next = @currentChapter().previousSlide()
    if next?
      @currentChapter().current = next
      @update()

  switchNextSlide: () =>
    curr = @currentChapter().currentSlide()
    next = @currentChapter().nextSlide()
    if next?
      @currentChapter().current = next
      @update()

  resize: (event) =>

  swipe: (event, direction, distance, duration, fingerCount) =>
    switch direction
      when "left"
        @switchNextChapter()
      when "right"
        @switchPreviousChapter()
      when "up"
        @switchNextSlide()
      when "down"
        @switchPreviousSlide()

  keydown: (event) =>
    if not $(document.activeElement).is(":input,[contenteditable]")
      switch event.which
        when 27 # escape
          @element.toggleClass("overview")
        when 37 # left
          @switchPreviousChapter()
        when 39 # right
          @switchNextChapter()
        when 38 # up
          @switchPreviousSlide()
        when 40 # down
          @switchNextSlide()
    else
      switch event.which
        when 27 # escape
          $(document.activeElement).blur()

  @translate: (element, x, y) ->
    $(element).css({
      "-webkit-transform": "translate(#{x}px, #{y}px)"
      "-moz-transform": "translate(#{x}px, #{y}px)"
      "-ms-transform": "translate(#{x}px, #{y}px)"
      "-o-transform": "translate(#{x}px, #{y}px)"
      "transform": "translate(#{x}px, #{y}px)"
    })

window.Presentation = Presentation
