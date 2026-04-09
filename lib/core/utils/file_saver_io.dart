import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> saveAndShareFile(Uint8List bytes, String filename, String shareText) async {
  final dir = await getTemporaryDirectory();
  final path = '${dir.path}/$filename';
  await File(path).writeAsBytes(bytes);
  await Share.shareXFiles([XFile(path)], text: shareText);
}
