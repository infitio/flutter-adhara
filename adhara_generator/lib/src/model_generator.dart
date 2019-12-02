import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';


class AdharaModelGenerator extends Generator {
  // Allow creating via `const` as well as enforces immutability here.
  const AdharaModelGenerator();

  TypeChecker get typeChecker => TypeChecker.fromRuntime(AdharaModelGenerator);

  matchesClass(InterfaceType interfaceType, String interfaceName, String sourceLibraryPath){
    return interfaceType.name == interfaceName
        && interfaceType.element.source.fullName == sourceLibraryPath;
  }

  getBuiltValueFields(FieldElement builtValueField){
    String str = '';
    LibraryReader reader = LibraryReader(builtValueField.type.element.library);
//    str += '00. ${reader.annotatedWith(typeChecker)}\n';
    for(ClassElement classElement in reader.classes){
      if(classElement.interfaces.any((interfaceType) =>
          matchesClass(interfaceType, "Built", "/built_value/lib/built_value.dart")
      )){
        for(FieldElement field in classElement.fields){
//          field.enclosingElement.metadata;
          str+='0. ${field.name} -- ${field.type} === ${field.librarySource} // ${field.metadata}'
              '\n${1}';
        }
      }
    }
    return str+'1. ${builtValueField.type.element.enclosingElement}\n'
        '2. ${builtValueField.type.element.enclosingElement.librarySource}\n'
        '2.1. ${builtValueField.name}\n'
        '3. ${builtValueField.type.element.name}\n'
        '4. ${builtValueField.type.element.displayName}\n'
        '5. ${builtValueField.type.element.librarySource.contents}\n'
        '6. ${reader.classes}\n';
  }

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    var result = StringBuffer();
    for(ClassElement classElement in library.classes){
      if(classElement.allSupertypes.any((interfaceType){
        return matchesClass(interfaceType, "Model", "/adhara/lib/datainterface/models/base.dart");
      })){
        result.writeln('/*');
        result.writeln('${library.classes} \n\n //${library.classes.map((ClassElement e) => e.source.fullName)} \n\n');
        for(FieldElement field in classElement.fields){
          if(field.name == "builtValue"){
            result.writeln(getBuiltValueFields(field));
          }
        }
        result.writeln('*/');
      }
    }
    if(result.isEmpty) return null;

    return '$result'
        '\n'      //Ignoring IDE errors -- Credits to built_value developers: https://github.com/google/built_value.dart/blob/master/built_value_generator/lib/built_value_generator.dart#L62
        '// ignore_for_file: '
        'always_put_control_body_on_new_line,'
        'always_specify_types,'
        'annotate_overrides,'
        'avoid_annotating_with_dynamic,'
        'avoid_as,'
        'avoid_catches_without_on_clauses,'
        'avoid_returning_this,'
        'lines_longer_than_80_chars,'
        'omit_local_variable_types,'
        'prefer_expression_function_bodies,'
        'sort_constructors_first,'
        'test_types_in_equals,'
        'unnecessary_const,'
        'unnecessary_new';
  }

}
