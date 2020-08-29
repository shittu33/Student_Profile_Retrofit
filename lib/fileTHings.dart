import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String> get _privatelocalPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<String> get _publiclocalPath async {
  final directory = await getExternalStorageDirectory();

  return directory.path;
}

Future<String> get tempPath async {
  final directory = await getExternalStorageDirectory();
  return directory.path;
}

Future<File> writeByteToFile(Uint8List bytes, String createdPath) async {
  return File(createdPath).writeAsBytes(bytes);
}

Future<Uint8List> writeByteFromFile(File file) async {
  return file.readAsBytes();
}
