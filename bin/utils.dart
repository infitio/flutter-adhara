import 'dart:io';
import 'dart:async';

Future<bool> isProjectRootDirectory() async {
  return await FileSystemEntity.isFile("pubspec.yaml");
}
