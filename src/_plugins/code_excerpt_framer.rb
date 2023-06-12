module DartSite

  # Takes the given code excerpt (with the given attributes) and creates
  # some framing HTML: e.g., a div with possible excerpt title in a header.
  class CodeExcerptFramer
    def frame_code(title, classes, attrs, escaped_code, indent, secondary_classes)
      _unindented_template(title, classes, attrs, escaped_code.gsub('\\','\\\\\\\\'), secondary_classes)
    end

    private
    # @param [String] div_classes, in the form "foo bar"
    # @param [Hash] attrs: attributes as attribute-name/value pairs.
    def _unindented_template(title, _div_classes, attrs, escaped_code, secondary_classes)
      div_classes = ['code-excerpt']
      div_classes << _div_classes if _div_classes

      pre_classes = attrs[:class] || []
      pre_classes.unshift("lang-#{attrs[:lang]}") if attrs[:lang]
      pre_classes.unshift('prettyprint')

      # If secondary class is not a dartpad command
      # (run-dartpad, start-dartpad, end-dartpad, file-),
      # include them on the pre block.
      unless secondary_classes.nil?
        unless (secondary_classes.include? '-dartpad') || (secondary_classes.include? 'file-')
          pre_classes.append(secondary_classes.split(' '))
          secondary_classes = ''
        else
          pre_classes = []
        end
      end

      # Was:             <code>escaped_code</code>!n
      # Also had: <copy-container></copy-container>

      # Ensure that the template starts and ends with a blank line.
      # We're rendering to markdown, and we don't want the frame HTML
      # to be adjacent to any text, otherwise the text might not be rendered
      # as a paragraph (e.g., esp. if inside an <li>).
      <<~TEMPLATE.gsub(/!n\s*/,'').sub(/\bescaped_code\b/,escaped_code)

        <div class="#{div_classes * ' '}">
        #{title ? "<div class=\"code-excerpt__header\">#{title}</div>" : '!n'}
        <div class="code-excerpt__code">!n
          <pre class="#{pre_classes * ' '}">!n
            <code class="#{secondary_classes}">!n
              escaped_code!n
            </code>!n
          </pre>!n
        </div>
        </div>

      TEMPLATE
    end
  end
end
