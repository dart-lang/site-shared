# Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

require 'liquid/tag/parser' # https://github.com/envygeeks/liquid-tag-parser
require_relative 'dart_site_util'
require_relative 'prettify_core'

module Jekyll

  module Tags

    # Wraps code with tags for Prettify.
    #
    # Arguments:
    #
    # - The first unnamed optional argument is the prettifier lang argument.
    #   Use 'nocode' or 'none' as the language to turn off prettifying.
    # - class="..."
    # - tag="...". See [PrettifyCore.code2html()] for a description of
    #   accepted tag specifiers. Defaults to 'pre'.
    #
    # Example usage:
    #
    # {% prettify dart %}
    #   var hello = 'world';
    # {% endprettify %}
    #
    class Prettify < Liquid::Block

      def initialize(tag_name, string_of_args, tokens)
        super
        @args = Liquid::Tag::Parser.new(string_of_args).args
      end

      def render(_context)
        helper = DartSite::PrettifyCore.new
        helper.code2html(super,
                         lang: @args[:argv1],
                         tag_specifier: @args[:tag],
                         user_classes: @args[:class])
      end

    end
  end
end

Liquid::Template.register_tag('prettify', Jekyll::Tags::Prettify)
