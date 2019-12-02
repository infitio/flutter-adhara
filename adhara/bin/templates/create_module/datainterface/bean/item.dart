import 'package:adhara/adhara.dart';

class Item extends Bean {
  static const String ID = "id";
  static const String EMPLOYEE_NAME = "employee_name";
  static const String EMPLOYEE_SALARY = "employee_salary";
  static const String EMPLOYEE_AGE = "employee_age";
  static const String PROFILE_IMAGE = "profile_image";

  Item([data]) : super(data);

  int get id => data[ID];

  String get name => convertToString(data[EMPLOYEE_NAME]);

  String get salary => convertToString(data[EMPLOYEE_SALARY], "-");

  String get age => convertToString(data[EMPLOYEE_AGE], "-");

  set profileImage(String _image) => data[PROFILE_IMAGE] = _image;

//  To be used while serializing data for DB storage
//  Map<String, dynamic> toSerializableMap() {
//    Map<String, dynamic> srMap = new Map<String, dynamic>.from(data);
//    return srMap;
//  }

//  To be used while sending data to network
//  Map<String, dynamic> toNetworkSerializableMap() {
//    return {
//      EMPLOYEE_NAME: data[EMPLOYEE_NAME],
//      EMPLOYEE_SALARY: data[EMPLOYEE_SALARY],
//      EMPLOYEE_AGE: data[EMPLOYEE_AGE],
//      PROFILE_IMAGE: data[PROFILE_IMAGE]
//    };
//  }

}
