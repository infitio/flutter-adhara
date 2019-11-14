import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';


class AdharaModelGenerator extends Generator {
  // Allow creating via `const` as well as enforces immutability here.
  const AdharaModelGenerator();

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    var result = StringBuffer();
    result.writeln("//PROTA!!! ADHARA");
    return result.toString();
  }

}
