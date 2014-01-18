module Jekyll

  class Slide
    attr_accessor :markdown
    attr_accessor :html

    def initialize(site, markdown)
      converter = Converters::Markdown.new site.config

      @markdown = markdown
      @html = converter.convert(markdown)
    end

    def to_liquid
      {
        "markdown" => @markdown,
        "html" => @html
      }
    end
  end

  class Chapter
    attr_accessor :data
    attr_accessor :slides

    def initialize(site, data, markdown)
      @data = data
      @slides = [Slide.new(site, markdown)]
    end

    def to_liquid
      {
        "slides" => @slides
      }
    end
  end

  class SlidezPage < Page
    def initialize(site, base, dir, name, chapters)
      super(site, base, dir, name)
      self.data["chapters"] = chapters
    end
  end

  class SlidezGenerator < Generator
    safe true

    def generate(site)
      # find chapters
      chapters = site.pages
        .select { |p| self.is_chapter(p) }
        .map { |c| Chapter.new(site, c.data, c.content) }

      # remove chapters from pages
      site.pages = site.pages.select { |p| not self.is_chapter(p) }

      # generate the slidez page
      site.pages << SlidezPage.new(site, site.source, "", "index.html", chapters)
    end

    def is_chapter(page)
      page.dir == "/chapters"
    end
  end

end
