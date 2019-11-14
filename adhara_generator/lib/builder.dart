import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:adhara_generator/src/model_generator.dart';

Builder modelFactory(BuilderOptions options){
  print("creating a sharedPartBuilder for adhara models");
  return SharedPartBuilder([AdharaModelGenerator()], 'adhara_model');
}