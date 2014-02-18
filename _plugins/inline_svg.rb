module Jekyll
  class InlineSvgTag < Jekyll::Tags::IncludeTag
    SVG_NAMESPAE = "http://www.w3.org/2000/svg"

    def source(file, context)
      site = context.registers[:site]
      params = parse_params(context) || {}
      options = {}.merge(site.config["inline_svg"] ||= {})
      scale = params["scale"] || 1.0

      svg = File.read(file, file_read_opts(context))
      svg = svg.sub /<\?.*\?>/, ""
      svg = svg.sub /<\!DOCTYPE.*>/, ""
      svg = svg.sub /<\!\-\-.*\-\->/, ""

      scale(svg, scale.to_f)
    end

    def scale(svgString, scale)
      require 'rexml/document'
      svg = REXML::Document.new(svgString)

      width = parseCoordinate(svg.root.attributes["width"])
      height = parseCoordinate(svg.root.attributes["height"])
      viewBox = svg.root.attributes["viewBox"]

      if viewBox
        svg.root.attributes["width"] = width * scale
        svg.root.attributes["height"] = height * scale
      else
        svg.root.attributes["viewBox"] = "0 0 #{width} #{height}"
        svg.root.attributes["width"] = width * scale
        svg.root.attributes["height"] = height * scale
      end

      svg.to_s()
    end

    def parseCoordinate(str)
      /^\s*(\d+(\.\d*)?)\s*(px)?\s*$/.match(str)[1].to_f
    end
  end
end

Liquid::Template.register_tag('inline_svg', Jekyll::InlineSvgTag)
