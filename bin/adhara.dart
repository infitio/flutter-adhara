import 'package:args/command_runner.dart';
import 'create-module.dart';
import 'setup-app.dart';
import './utils/structureutils.dart';

main(List<String> arguments) {
  isProjectRootDirectory().then((isRoot){
    if(isRoot) {
      var runner = new CommandRunner("git", "Distributed version control.")
        ..addCommand(AppCommand())..addCommand(ModuleCommand());
      runner.run(arguments);
    }else{
      throw Exception("pubspec.yaml not found. Please run the commands in project root directory...");
    }
  });
}
