module Jekyll
  class InlineLessTag < Jekyll::Tags::IncludeTag
    def source(file, context)
      require 'less'
      site = context.registers[:site]
      params = parse_params(context) || {}
      options = {"compress" => true}.merge(site.config["inline_less"] ||= {})

      less = File.read(file, file_read_opts(context))
      css = ::Less::Parser.new({ :paths => [File.dirname(file)] }).parse(less).to_css(options)
      css = "<style type=\"text/css\">" + css + "</style>"

      css
    end
  end
end

Liquid::Template.register_tag('inline_less', Jekyll::InlineLessTag)
