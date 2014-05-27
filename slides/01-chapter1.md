{% inline_svg images/javascript.svg scale='0.25' %}

{% graphviz %}
digraph graphname
{
  a -> b -> c;
  b -> d;
  k -> a;
  a -> k;
  d -> a [style=dashed];

  { rank=same; b d }
  { rank=same; c k }
}
{% endgraphviz %}

---

# Next Hello World

~~~ jade
doctype html
html
  head
    body(id="body")
~~~

---

# CoffeeScript

~~~ coffee
class Name
  constructor: (@firstName, @lastName) ->
  greet: () => console.log "Hello #{@firstName}!"
~~~

---

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

---

# Next Hello World

~~~ jade
doctype html
html
  head
    body(id="body")
~~~

---

# Next Hello World

~~~ jade
doctype html
html
  head
    body(id="body")
~~~

---

# Next Hello World

~~~ jade
doctype html
html
  head
    body(id="body")
~~~

---

# Next Hello World

~~~ jade
doctype html
html
  head
    body(id="body")
~~~

---

# Next Hello World

~~~ jade
doctype html
html
  head
    body(id="body")
~~~
