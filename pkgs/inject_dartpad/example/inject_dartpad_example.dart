import 'package:inject_dartpad/inject_dartpad.dart';
import 'package:web/web.dart' as web;

void main() async {
  final dartPad = EmbeddedDartPad.create(
    iframeId: 'my-dartpad',
    theme: DartPadTheme.light,
  );

  await dartPad.initialize(
    addToDocument: (iframe) {
      iframe.style.height = '560';

      web.document.body!.append(iframe);
    },
  );

  dartPad.updateCode('''
void main() {
  print("Hello, I'm Dash!");
}''');
}
