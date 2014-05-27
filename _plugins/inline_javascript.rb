module Jekyll
  class InlineJavascriptTag < Jekyll::Tags::IncludeTag
    def source(file, context)
      site = context.registers[:site]
      params = parse_params(context) || {}
      options = {}.merge(site.config["inline_javascript"] ||= {})

      js = File.read(file, file_read_opts(context))
      js = "<script type=\"text/javascript\">" + js + "</script>"

      js
    end
  end
end

Liquid::Template.register_tag('inline_javascript', Jekyll::InlineJavascriptTag)
