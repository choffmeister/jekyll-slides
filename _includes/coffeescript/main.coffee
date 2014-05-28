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
    @element.wrapInner("<div class=\"center\"></div>")
    @originalWidth = originalWidth or 800
    @originalHeight = originalHeight or 600
    @ratio = @originalWidth / @originalHeight

  init: () =>
    @chapters = _.chain(@element.children(".center").children(".chapter"))
      .map((c, i) => new Chapter(this, c, i))
      .filter((c) => c.slides.length > 0)
      .value()
    @current = _.first(@chapters)
    @arrange()

    # register event handler
    $(window).swipe { swipe: @swipe }
    $(window).keydown (event) => @keydown(event)
    $(window).resize (event) => @resize()
    @resize()

    # animation is blocked until the inital arrangement has been done
    window.setTimeout((() => @element.addClass("animated")), 0)

  arrange: () =>
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

  switchPreviousChapter: () =>
    curr = @currentChapter()
    next = @previousChapter()
    if next?
      @current = next
      @arrange()

  switchNextChapter: () =>
    curr = @currentChapter()
    next = @nextChapter()
    if next?
      @current = next
      @arrange()

  switchPreviousSlide: () =>
    curr = @currentChapter().currentSlide()
    next = @currentChapter().previousSlide()
    if next?
      @currentChapter().current = next
      @arrange()

  switchNextSlide: () =>
    curr = @currentChapter().currentSlide()
    next = @currentChapter().nextSlide()
    if next?
      @currentChapter().current = next
      @arrange()

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
