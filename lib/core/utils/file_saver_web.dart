import 'dart:html' as html;
import 'dart:typed_data';

Future<void> saveAndShareFile(Uint8List bytes, String filename, String shareText) async {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..download = filename
    ..click();
  html.Url.revokeObjectUrl(url);
}
