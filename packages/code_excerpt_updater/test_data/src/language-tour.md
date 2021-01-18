## Basic prettify tests

### Without arguments

<?code-excerpt "quote.md"?>
{% prettify %}
...
{% endprettify %}

### With language argument

<?code-excerpt "basic.dart (greeting)"?>
{% prettify dart %}
...
{% endprettify %}

<?code-excerpt "no_region.html"?>
{% prettify html %}
{% endprettify %}

### With other arguments

<?code-excerpt "no_region.html"?>
{% prettify html tag="code" %}
{% endprettify %}

### With strip-whitespace syntax

<?code-excerpt "no_region.html"?>
{% prettify html tag="code+br" -%}
{%- endprettify %}

<?code-excerpt "basic.dart (greeting)"?>
{%- prettify dart -%}
{%- endprettify -%}
