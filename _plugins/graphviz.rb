module Jekyll
  class GraphVizBlock < Liquid::Block
    def safe
      true
    end

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      require 'graphviz'

      content = super.strip
      svg = GraphViz.parse_string(content).output(:svg => String)

      "<p class=\"graph\">#{svg}</p>"
    end
  end
end

Liquid::Template.register_tag('graphviz', Jekyll::GraphVizBlock)
