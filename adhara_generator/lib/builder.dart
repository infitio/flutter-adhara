import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:adhara_generator/src/model_generator.dart';

Builder modeFactory(BuilderOptions options) =>
    SharedPartBuilder([AdharaModelGenerator()], 'adhara_model');
