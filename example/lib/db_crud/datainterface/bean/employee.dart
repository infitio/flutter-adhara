import 'package:adhara/adhara.dart';

class Employee extends Bean {

  static const String EMPLOYEE_NAME = "employee_name";
  static const String EMPLOYEE_SALARY = "employee_salary";
  static const String EMPLOYEE_AGE = "employee_age";
  static const String PROFILE_IMAGE = "profile_image";

  Employee([data]) : super(data);

  String get name => convertToString(data[EMPLOYEE_NAME]);
  set name(String _) => data[EMPLOYEE_NAME] = _;

  double get salary => double.parse(data[EMPLOYEE_SALARY].toString());
  set salary(double _) => data[EMPLOYEE_SALARY] = _;

  int get age => data[EMPLOYEE_AGE];
  set age(int _) => data[EMPLOYEE_AGE] = _;

  set profileImage(String _image) => data[PROFILE_IMAGE] = _image;

}
