import 'package:test/test.dart';

import 'package:adhara_generator/builder.dart';
import 'package:build_test/build_test.dart';

void main() {
//  testBuilder(
//      modelFactory(null),
//      {
//        'assets': 'test/in'
//      }
//  );
  test('adds one to input values', () {
    expect(1+2, 3);
    expect(1-7, -6);
    expect(0+1, 1);
  });
}
