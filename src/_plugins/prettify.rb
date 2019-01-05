# Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

require 'cgi'
require 'liquid/tag/parser' # https://github.com/envygeeks/liquid-tag-parser
require_relative 'dart_site_util'

module Jekyll

  module Tags

    # Wraps code with tags for Prettify.
    #
    # Arguments:
    #
    # - The first unnamed optional argument is the prettifier lang argument.
    #   Use 'nocode' or 'none' as the language to turn of prettifying.
    # - class="..."
    # - tag="pre|pre+code|code|code+br". The HTML element used to wrap the prettified code.
    #   Default is pre. The `code` element is used for `code+br`; in addition,
    #   newlines in the code excerpt are reformatted at `<br>` elements.
    #
    # Example usage:
    #
    # {% prettify dart %}
    # var hello = 'world';
    # {% endprettify %}
    #
    class Prettify < Liquid::Block

      def initialize(tag_name, string_of_args, tokens)
        super
        @args = Liquid::Tag::Parser.new(string_of_args).args
        @lang = @args[:argv1]
        @tag = @args[:tag] || 'pre'
        @tag = 'code' if @tag == 'code+br'
        init_css_classes
      end

      def init_css_classes
        @css_classes = []
        unless @lang == 'nocode' || @lang == 'none'
          @css_classes << 'prettyprint'
          @css_classes << "lang-#{@lang}" if @lang
        end
        @css_classes << @args[:class] if @args[:class]
      end

      def class_attr
        @css_classes.empty? ? '' : " class=\"#{@css_classes.join(' ')}\""
      end

      def render(context)
        out = "<#{@tag}#{class_attr}>"
        out += '<code>' if @tag == 'pre+code'

        code = DartSite::Util.block_trim_leading_whitespace(super.split(/\n/)).join("\n")
        # Strip leading and trailing whitespace so that <pre> and </pre> tags wrap tightly
        code.strip!
        code = CGI.escapeHTML(code)

        if @args[:tag] == 'code+br'
          code.gsub!(/\n[ \t]*/) { |s|
            "<br>\n#{'&nbsp;' * (s.length - 1)}"
          }
        end

        # Names of tags previously supported: highlight, note, red, strike.
        code.gsub!(/\[\[([\w-]+)\]\]/, '<span class="\1">')
        code.gsub!(/\[\[\/([\w-]*)\]\]/, '</span>')

        # Flutter tag syntax variant:
        code.gsub!(/\/\*\*([\w-]+)\*\//, '<span class="\1">')
        code.gsub!(/\/\*-([\w-]*)\*\//, '</span>')

        code.gsub!('[!', '<span class="highlight">')
        code.gsub!('!]', '</span>')

        out += code
        out += '</code>' if @tag == 'pre+code'
        out += "</#{@tag}>"
      end
    end
  end
end

Liquid::Template.register_tag('prettify', Jekyll::Tags::Prettify)
