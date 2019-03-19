import 'utils.dart';
import 'package:args/command_runner.dart';
import 'start-module.dart';
import 'start-app.dart';

main(List<String> arguments) {
  isProjectRootDirectory().then((isRoot){
    if(isRoot) {
      var runner = new CommandRunner("git", "Distributed version control.")
        ..addCommand(AppCommand())..addCommand(ModuleCommand());
      runner.run(arguments);
    }else{
      throw Exception("Please run the commands in project root directory...");
    }
  });
}
