##
## Kramdown plugin extension.
##
## Converts markdown code blocks preceded by a processing instruction (PI) of the form
## <?code-excerpt?> into:
## 
## - <code-example> elements suitable for use in Angular docs.
## - diff2html elements
##

require 'cgi'
require_relative 'code_excerpt_processor'

module Jekyll
  class NgMarkdown < Converter
    priority :high

    def matches(ext)
      ext =~ /^\.md$/i
    end

    def output_ext(_ext)
      '.html'
    end

    def convert(content)
      # Unescape {!{ ... }!} back to Angular {{ }}
      content.gsub!(/{!{/, '{{') # &#123;&#123;
      content.gsub!(/}!}/, '}}') # &#125;&#125;

      @cep ||= NgCodeExcerpt::MarkdownProcessor.new()
      @cep.code_excerpt_processing_init()
      content.gsub!(@cep.code_excerpt_regex) {
        @cep.process_code_excerpt(Regexp.last_match)
      }

      @base_conv ||= Converters::Markdown::KramdownParser.new(@config)
      @base_conv.convert(content)
    end
  end
end
