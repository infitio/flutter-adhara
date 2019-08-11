import 'package:args/command_runner.dart';


class ModuleCommand extends Command {
  final String name = "create_module";
  final String description = "Create module for adhara app";

  ModuleCommand() {
    argParser.addOption('name', abbr: 'n', help: 'create a module with this name');
  }

  void run() {
    print(argResults['name']);
  }

}
