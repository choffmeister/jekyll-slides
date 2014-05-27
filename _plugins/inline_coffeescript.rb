module Jekyll
  class InlineCoffeescriptTag < Jekyll::Tags::IncludeTag
    def source(file, context)
      require 'coffee-script'
      site = context.registers[:site]
      params = parse_params(context) || {}
      options = {}.merge(site.config["inline_coffeescript"] ||= {})

      coffee = File.read(file, file_read_opts(context))
      js = CoffeeScript.compile(coffee, options)
      js = "<script type=\"text/javascript\">" + js + "</script>"

      js
    end
  end
end

Liquid::Template.register_tag('inline_coffeescript', Jekyll::InlineCoffeescriptTag)
