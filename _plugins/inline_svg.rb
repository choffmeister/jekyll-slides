module Jekyll
  class InlineSvgTag < Jekyll::Tags::IncludeTag
    def source(file, context)
      site = context.registers[:site]
      params = parse_params(context) || {}
      options = {}.merge(site.config["inline_svg"] ||= {})

      svg = File.read(file, file_read_opts(context))
      svg = svg.sub /<\?.*\?>/, ""
      svg = svg.sub /<\!DOCTYPE.*>/, ""
      svg = svg.sub /<\!\-\-.*\-\->/, ""

      svg
    end
  end
end

Liquid::Template.register_tag('inline_svg', Jekyll::InlineSvgTag)
