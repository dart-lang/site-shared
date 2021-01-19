## Basic prettify tests

### Without arguments

<?code-excerpt "quote.md"?>
{% prettify %}
This is a **markdown** fragment.
{% endprettify %}

### With language argument

<?code-excerpt "basic.dart (greeting)"?>
{% prettify dart %}
var greeting = 'hello';
var scope = 'world';
{% endprettify %}

<?code-excerpt "no_region.html"?>
{% prettify html %}
<div>
  <h1>Hello World!</h1>
</div>
{% endprettify %}

### With other arguments

<?code-excerpt "no_region.html"?>
{% prettify html tag="code" %}
<div>
  <h1>Hello World!</h1>
</div>
{% endprettify %}

### With strip-whitespace syntax

<?code-excerpt "no_region.html"?>
{% prettify html tag="code+br" -%}
<div>
  <h1>Hello World!</h1>
</div>
{%- endprettify %}

<?code-excerpt "basic.dart (greeting)"?>
{%- prettify dart -%}
var greeting = 'hello';
var scope = 'world';
{%- endprettify -%}
