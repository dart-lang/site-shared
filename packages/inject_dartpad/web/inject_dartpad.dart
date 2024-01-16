// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';

import 'package:html_unescape/html_unescape_small.dart';
import 'package:web/web.dart';

const String _iframePrefix = 'https://preview.dartpad.dev/';

void main() {
  // Select all `code` elements with the `dartpad` attribute that are
  // the only child of a `pre` element.
  final codeElements =
      document.querySelectorAll('pre > code[data-dartpad]:only-child');

  for (var index = 0; index < codeElements.length; index += 1) {
    final codeElement = codeElements.item(index) as HTMLElement;
    _injectEmbed(codeElement);
  }
}

final _htmlUnescape = HtmlUnescape();

void _injectEmbed(HTMLElement codeElement) {
  final parent = codeElement.parentElement;
  if (parent == null) return;

  final attributes = [
    if (codeElement.getAttribute('data-embed') != 'false') 'embed=true',
    if (codeElement.getAttribute('data-theme') == 'light') 'theme=light',
    if (codeElement.getAttribute('data-run') == 'true') 'run=true',
  ];

  final String iframeUrl;
  if (attributes.isNotEmpty) {
    iframeUrl = '$_iframePrefix?${attributes.join('&')}';
  } else {
    iframeUrl = _iframePrefix;
  }

  final host = document.createElement('div') as HTMLElement;
  final iframe = document.createElement('iframe') as HTMLIFrameElement;

  iframe.setAttribute('src', iframeUrl);
  if (codeElement.getAttribute('title') case final title?
      when title.isNotEmpty) {
    iframe.setAttribute('title', title);
  }

  iframe.classList.add('embedded-dartpad');

  if (codeElement.getAttribute('data-width') case final width?
      when width.isNotEmpty) {
    iframe.style.width = width;
  }

  if (codeElement.getAttribute('data-height') case final height?
      when height.isNotEmpty) {
    iframe.style.height = height;
  }

  host.appendChild(iframe);
  parent.replaceWith(host as JSAny);

  final content = _htmlUnescape.convert(codeElement.innerHTML.trimRight());

  window.addEventListener(
    'message',
    (MessageEvent event) {
      if ((event.data as _EmbedReadyMessage).type == 'ready') {
        iframe.contentWindow!.postMessage(
          {'sourceCode': content, 'type': 'sourceCode'}.jsify(),
          '*'.toJS,
        );
      }
    }.toJS,
  );
}

@JS()
@staticInterop
final class _EmbedReadyMessage {}

extension on _EmbedReadyMessage {
  external String get type;
}
