import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

 Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
 
  Future<File> localFile(String filename) async {
    final path = await localPath;
    return File('$path/$filename.txt');
  }

  Future<String> readFile(String filename) async {
    try {
      final file = await localFile(filename);
 
      String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }
 
  Future<File> writeFile(String text, String filename) async {
    final file = await localFile(filename);
    return file.writeAsString('$text\r\n', mode: FileMode.append);
  }
 
  Future<File> cleanFile(String filename) async {
    final file = await localFile(filename);
    return file.writeAsString('');
  }

