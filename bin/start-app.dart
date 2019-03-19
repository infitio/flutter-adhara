import 'package:args/command_runner.dart';


class AppCommand extends Command {
  final String name = "create_app";
  final String description = "Create adhara app";

  AppCommand() {
    argParser.addOption('name', abbr: 'n', help: 'create an app with this name');
  }

  void run() {
    print(argResults['name']);
  }

}
