import 'dart:io';
import "./utils/structureutils.dart";
import 'base_command.dart';


class ModuleCommand extends BaseCommand{
  final String name = "create_module";
  final String description = "Create module for adhara app";
  String moduleName;

  ModuleCommand() {
    argParser.addOption('name', abbr: 'n', help: 'create a module with this name');
  }

  Future run() async {
    moduleName = argResults['name'];
    if(moduleName==null){
      print("name is a required argument");
      return;
    }
    if(dirExists('lib/$moduleName')){
      print("module already exists");
      return;
    }
    await createModuleFile();
  }

  Future createModuleFile() async {
    print("creating module file...");
    createDirs('lib/$moduleName');
    await copyDirectory(
        Directory(resolveToTemplatesPath(['datainterface'])),
        Directory(joinPathTokens(['lib', moduleName, 'datainterface']))
    );
    await copyDirectory(
        Directory(resolveToTemplatesPath(['views'])),
        Directory(joinPathTokens(['lib', moduleName, 'views']))
    );
//    String content = await this.getFileContentsForTemplate(['module.dart'], {"moduleName": moduleName});
//    createFile(['lib', moduleName, 'module.dart'], content);
    await copyFile(
        File(resolveToTemplatesPath(['module.dart'])),
        File(joinPathTokens(['lib', moduleName, 'module.dart'])),
        context: {"moduleName": moduleName}
    );
  }

}
