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
    attr_accessor :slides

    def initialize(site, content)
      @slides = content
        .gsub("\r\n", "\n")
        .gsub("\r", "\n")
        .split(/^\-{3,}$/)
        .map { |s| s.strip }
        .select { |s| s.length > 0 }
        .map { |s| Slide.new(site, s) }
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
      dir = File.join(site.source, "_chapters")
      files = File.join(dir, "*.md")

      # read chapters
      chapters = Dir.glob(files)
        .map { |f| File.read(f) }
        .map { |c| Chapter.new(site, c) }

      # generate the slidez page
      site.pages << SlidezPage.new(site, site.source, "", "index.html", chapters)
    end
  end

end
