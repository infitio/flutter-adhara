import 'dart:io';

import 'package:path/path.dart' as path;
import "package:path/path.dart" show join, dirname, split;

Future<bool> isProjectRootDirectory() async {
  return await FileSystemEntity.isFile("pubspec.yaml");
}

bool dirExists(path) {
  print("DEX:: $path");
  Directory newDir = new Directory(path);
  return newDir.existsSync();
}

void createDirs(path) {
  Directory newDir = new Directory(path);
  if (newDir.existsSync()) {
    print("dir $path already exists");
    return null;
  }
  newDir.createSync(recursive: true);
}

joinPathTokens(List<String> tokens) {
  String requiredPath;
  for (String token in tokens) {
    if (requiredPath == null) {
      requiredPath = token;
    } else {
      requiredPath = join(requiredPath, token);
    }
  }
  return requiredPath;
}

String getTemplatesPath(List<String> pathTokens) {
  String binPath = dirname(Platform.script.toString());
  print("Platform ${Platform.operatingSystem}");
  String path = joinPathTokens(
      [binPath.replaceFirst("file:///", ""), 'templates', ...pathTokens]);
  if (Platform.isWindows) return path;
  return '/' + path;
}

Future createFile(String filePath, String contents) async {
  List<String> _path = split(filePath);
  _path.removeLast();
  String dirPath = joinPathTokens(_path);
  createDirs(dirPath);
  return File(filePath).writeAsStringSync(contents);
}

Future copyFile(File source, File destination,
    {Map<String, dynamic> context}) async {
  String contents = await source.readAsString();
  if (context != null) {
    contents = contents
        .replaceAllMapped(RegExp("{{([a-zA-Z\$_][a-zA-Z0-9\$_]*)}}"), (match) {
      return context[match.group(1)];
    });
  }
  createFile(destination.path, contents);
}

Future copyDirectory(Directory source, Directory destination) async {
  createDirs(destination.absolute.path);
  source.listSync(recursive: false).forEach((var entity) {
    if (entity is Directory) {
      var newDirectory = Directory(
          path.join(destination.absolute.path, path.basename(entity.path)));
      newDirectory.createSync();
      copyDirectory(entity.absolute, newDirectory);
    } else if (entity is File) {
      entity.copySync(path.join(destination.path, path.basename(entity.path)));
    }
  });
}
