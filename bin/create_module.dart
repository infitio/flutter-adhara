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
    if(dirExists(moduleName)){
      print("module already exists");
      return;
    }
    await createModuleFile();
  }

  Future createModuleFile() async {
    print("creating module file...");
    createDirs(name);
    String content = await this.getFileContentsForTemplate(['module.dart.hbs'], {"moduleName": moduleName});
    createFile(['lib', moduleName, 'module.dart'], content);
  }

}
