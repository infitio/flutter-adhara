import 'dart:io';
import 'package:path/path.dart' as path;
import "package:path/path.dart" show join, dirname;


Future<bool> isProjectRootDirectory() async {
  return await FileSystemEntity.isFile("pubspec.yaml");
}

Future<String> createDirs(path) async {
  Directory newDir = new Directory(path);
  if(newDir.existsSync()){
    return null;
  }
  Directory directory = await newDir.create(recursive: true);
  return directory.path;
}

Directory getTemplatesPath(List<String> pathTokens){
  String binPath = dirname(Platform.script.toString());
  binPath = binPath.substring(8);
  String requiredPath = join(binPath, 'templates');
  for(String token in pathTokens){
    join(requiredPath, token);
  }
  return Directory(requiredPath);
}


Future copyDirectory(Directory source, Directory destination) async {
  await createDirs(destination.absolute.path);
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
