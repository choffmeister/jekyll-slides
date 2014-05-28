# jekyll-slides

_jekyll-slides_ is a [Jekyll](http://jekyllrb.com/) project template to generate beautiful HTML5 presentations from plain [Markdown](http://daringfireball.net/projects/markdown/). These presentations are self contained, i.e. every needed CSS, JavaScript and so on gets compiled into a single HTML file to make easy distribution possible.

## Examples

* [Dummy](http://choffmeister.github.io/jekyll-slides/examples/dummy.html)

## Getting started

First make sure you have [Ruby](https://www.ruby-lang.org/) and [Bundler](http://bundler.io/) installed. Then open up a terminal and execute:

~~~ bash
$ git clone https://github.com/choffmeister/jekyll-slides.git
$ cd jekyll-slides
$ bundle install
$ jekyll serve --watch
~~~

Now you can start watching your new presentation at [http://localhost:4000/](http://localhost:4000/). To add your own content just edit the markdown files in the `slides/` folder. The changes are automatically recompiled by Jekyll. Hence you only have to save your changes and refresh your browser.

## License

This project is licensed under the permissive [MIT](http://opensource.org/licenses/MIT) license.
