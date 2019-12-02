import 'package:args/command_runner.dart';

import './utils/structureutils.dart';
import 'create_module.dart';
import 'setup_app.dart';

main(List<String> arguments) {
  isProjectRootDirectory().then((isRoot) {
    if (isRoot) {
      var runner = new CommandRunner("adhara", "Distributed version control.")
        ..addCommand(AppCommand())
        ..addCommand(ModuleCommand());
      runner.run(arguments);
    } else {
      throw Exception(
          "pubspec.yaml not found. Please run the commands in project root directory...");
    }
  });
}
