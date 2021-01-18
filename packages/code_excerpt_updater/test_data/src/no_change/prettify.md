Regression test for https://github.com/dart-lang/site-www/pull/719.
Originally, when run on the code excerpt instruction below,
the code excerpt would be duplicated.

Also see `../prettify.md` and `language-tour.md` in this test folder for other prettify tests.

## API docs

Prettify block containing triple-backticks:

<?code-excerpt "backticks_in_api_doc.dart"?>
{% prettify html %}
/// ```html
/// <h1>HTML is magical!</h1>
/// ```
class HTML {}
{% endprettify %}
