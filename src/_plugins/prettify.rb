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
  # - tag="code|pre". The prettified code will be wrapped in this HTML tag.
  #   Default is pre.
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

      # Strip excess whitespace at the end (which will be present if the code is indented)
      contents = super.gsub /(\s*\n\s*)+\z/, ''
      contents = CGI::escapeHTML(contents)

      contents.gsub!('[[strike]]', '<code class="nocode strike">')
      contents.gsub!('[[/strike]]', '</code>')

      contents.gsub!('[[highlight]]', '<code class="nocode highlight">')
      contents.gsub!('[[/highlight]]', '</code>')

      contents.gsub!('[!', '<span class="highlight">')
      contents.gsub!('!]', '</span>')

      contents.gsub!('[[note]]', '<code class="nocode note">')
      contents.gsub!('[[/note]]', '</code>')

      contents.gsub!('[[red]]', '<code class="nocode red">')
      contents.gsub!('[[/red]]', '</code>')

      out += contents + "</#{@tag}>"
    end

  end
end

Liquid::Template.register_tag('prettify', Prettify::Tag)
