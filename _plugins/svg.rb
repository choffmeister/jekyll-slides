module Jekyll
  class InlineSvgTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      site = context.registers[:site]
      safe = site.safe
      options = {}.merge(site.config["svg"] ||= {})

      path = File.join(context.registers[:site].source, @text.strip)
      self.validate_dir(File.dirname(path), safe)
      self.validate_file(path, safe)

      svg = File.read(path)
      svg = svg.sub /<\?.*\?>/, ""
      svg = svg.sub /<\!DOCTYPE.*>/, ""
      svg = svg.sub /<\!\-\-.*\-\->/, ""

      svg
    end

    def validate_dir(dir, safe)
      if File.symlink?(dir) && safe
        raise IOError.new "Includes directory '#{dir}' cannot be a symlink"
      end
    end

    def validate_file(file, safe)
      if !File.exists?(file)
        raise IOError.new "Included file '#{file}' not found"
      elsif File.symlink?(file) && safe
        raise IOError.new "The included file '#{file}' should not be a symlink"
      end
    end
  end
end

Liquid::Template.register_tag('inline_svg', Jekyll::InlineSvgTag)
