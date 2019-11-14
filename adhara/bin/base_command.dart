import 'dart:io';
import 'package:args/command_runner.dart';
import "./utils/structureutils.dart";
import "package:path/path.dart" show join;


//abstract class TemplateHandler{

  // This class is intended to be used as a mixin, and should not be
  // extended directly.
//  factory TemplateHandler._() => null;


//}

abstract class BaseCommand extends Command{

  String resolveToTemplatesPath(List<String> path){
    return getTemplatesPath([name, ...path]);
  }

  String resolveToPath(List<String> path){
    return getTemplatesPath([name, ...path]);
  }

  Future createFile(List<String> path, String contents) async {
    String filePath = joinPathTokens(path);
    path.removeLast();
    String dirPath = joinPathTokens(path);
    createDirs(dirPath);
    return File(filePath).writeAsStringSync(contents);
  }

  Future<String> getFileContentsForTemplate(List<String> templateFilePath, Map context) async {
    String template = await new File(resolveToTemplatesPath(templateFilePath)).readAsString();
    return template.replaceAllMapped(RegExp("{{([a-zA-Z\$_][a-zA-Z0-9\$_]*)}}"), (match) {
      return context[match.group(1)];
    });
  }

}
