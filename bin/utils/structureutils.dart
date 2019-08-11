import 'dart:io';
import 'package:path/path.dart' as path;
import "package:path/path.dart" show join, dirname;


Future<bool> isProjectRootDirectory() async {
  return await FileSystemEntity.isFile("pubspec.yaml");
}

bool dirExists(path) {
  Directory newDir = new Directory(path);
  return newDir.existsSync();
}

void createDirs(path){
  Directory newDir = new Directory(path);
  if(newDir.existsSync()){
    return null;
  }
  newDir.createSync(recursive: true);
}

joinPathTokens(List<String> tokens){
  String requiredPath;
  for(String token in tokens){
    if(requiredPath==null){
      requiredPath = token;
    }else{
      requiredPath = join(requiredPath, token);
    }
  }
  return requiredPath;
}

String getTemplatesPath(List<String> pathTokens){
  String binPath = dirname(Platform.script.toString());
  return joinPathTokens([binPath.replaceFirst("file:///", ""), 'templates', ...pathTokens]);
}

Future copyDirectory(Directory source, Directory destination) async {
  createDirs(destination.absolute.path);
  source.listSync(recursive: false).forEach((var entity) {
    if (entity is Directory) {
      var newDirectory = Directory(path.join(destination.absolute.path, path.basename(entity.path)));
      newDirectory.createSync();
      copyDirectory(entity.absolute, newDirectory);
    } else if (entity is File) {
      entity.copySync(path.join(destination.path, path.basename(entity.path)));
    }
  });
}
