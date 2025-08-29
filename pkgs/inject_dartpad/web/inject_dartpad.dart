// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:html_unescape/html_unescape_small.dart';
import 'package:inject_dartpad/inject_dartpad.dart';
import 'package:web/web.dart' as web;

void main() async {
  // Select all `code` elements with the `dartpad` attribute that are
  // the only child of a `pre` element.
  final codeElements = web.document.querySelectorAll(
    'pre > code[data-dartpad]:only-child',
  );

  await [
    for (var index = 0; index < codeElements.length; index += 1)
      _injectEmbed(codeElements.item(index) as web.HTMLElement, index),
  ].wait;
}

Future<EmbeddedDartPad?> _injectEmbed(
  web.HTMLElement codeElement,
  int embedNumber,
) async {
  final parent = codeElement.parentElement;
  if (parent == null) return null;

  final content = _htmlUnescape.convert(
    codeElement.innerHTML.toString().trimRight(),
  );
  if (content.isEmpty) return null;

  final embeddedDartPad = EmbeddedDartPad.create(
    iframeId: 'embedded-dartpad-$embedNumber',
    host: switch (codeElement.getAttribute('data-url')) {
      final specifiedHost? when specifiedHost.isNotEmpty => specifiedHost,
      _ => null,
    },
    embedLayout: codeElement.getAttribute('data-embed') != 'false',
    theme: codeElement.getAttribute('data-theme') == 'light'
        ? DartPadTheme.light
        : DartPadTheme.auto,
  );

  await embeddedDartPad.initialize(
    addToDocument: (iframe) {
      iframe.classList.add('embedded-dartpad');
      if (codeElement.getAttribute('title') case final title?
          when title.isNotEmpty) {
        iframe.setAttribute('title', title);
      }

      if (codeElement.getAttribute('data-width') case final width?
          when width.isNotEmpty) {
        iframe.style.width = width;
      }

      if (codeElement.getAttribute('data-height') case final height?
          when height.isNotEmpty) {
        iframe.style.height = height;
      }

      final host = web.HTMLDivElement();
      host.appendChild(iframe);
      parent.replaceWith(host);

      final contentWindow = iframe.contentWindow;
      if (contentWindow == null) {
        host.replaceWith(parent);
        print('Failed to inject embedded DartPad with content:\n');
      }
    },
  );

  embeddedDartPad.updateCode(content);

  return embeddedDartPad;
}

final _htmlUnescape = HtmlUnescape();
