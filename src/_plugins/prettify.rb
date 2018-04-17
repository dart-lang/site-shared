# Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

require 'cgi'
require 'liquid/tag/parser' # https://github.com/envygeeks/liquid-tag-parser

module Prettify

  # Wraps code with tags for Prettify.
  #
  # Arguments:
  #
  # - The first unnamed optional argument is the prettifier lang argument.
  #   Use 'nocode' or 'none' as the language to turn of prettifying.
  # - class="..."
  # - tag="pre|code|code+br". The HTML element used to wrap the prettified code.
  #   Default is pre. The `code` element is used for `code+br`; in addition,
  #   newlines in the code excerpt are reformatted at `<br>` elements.
  #
  # Example usage:
  #
  # {% prettify dart %}
  # var hello = 'world';
  # {% endprettify %}

  class Tag < Liquid::Block

    def initialize(tag_name, stringOfArgs, tokens)
      super
      @args = Liquid::Tag::Parser.new(stringOfArgs).args
      @lang = @args[:argv1]
      @tag = @args[:tag] || 'pre'
      @tag = 'code' if @tag == 'code+br';
      initCssClasses
    end

    def initCssClasses
      @cssClasses = []
      unless @lang == 'nocode' || @lang == 'none'
        @cssClasses << 'prettyprint'
        @cssClasses << "lang-#{@lang}" if @lang
      end
      @cssClasses << @args[:class] if @args[:class]
    end

    def classAttr
      @cssClasses.empty? ? '' : " class=\"#{@cssClasses.join(' ')}\""
    end

    def render(context)
      out = "<#{@tag}#{classAttr}>"

      code = trimMinLeadingSpace(super)
      code = CGI::escapeHTML(code)

      if @args[:tag] == 'code+br'
        code.gsub!(/\n[ \t]*/) { |s|
          "<br>\n#{'&nbsp;' * (s.length - 1)}"
        }
      end

      code.gsub!('[[strike]]', '<code class="nocode strike">')
      code.gsub!('[[/strike]]', '</code>')

      code.gsub!('[[highlight]]', '<code class="nocode highlight">')
      code.gsub!('[[/highlight]]', '</code>')

      code.gsub!('[!', '<span class="highlight">')
      code.gsub!('!]', '</span>')

      code.gsub!('[[note]]', '<code class="nocode note">')
      code.gsub!('[[/note]]', '</code>')

      code.gsub!('[[red]]', '<code class="nocode red">')
      code.gsub!('[[/red]]', '</code>')

      out += code + "</#{@tag}>"
    end

    def trimMinLeadingSpace(code)
      lines = code.split(/\n/);
      while lines.first =~ /^\s*$/ do lines.shift; end
      while lines.last =~ /^\s*$/ do lines.pop; end

      nonblanklines = lines.reject { |s| s.match(/^\s*$/) }
      # Length of leading spaces to be trimmed
      len = nonblanklines.map{ |s|
          matches = s.match(/^[ \t]*/)
          matches ? matches[0].length : 0 }.min

      return len == 0 ? code :
        lines.map{|s| s.length < len ? s : s[len..-1]}.join("\n")
    end
  end
end

Liquid::Template.register_tag('prettify', Prettify::Tag)
