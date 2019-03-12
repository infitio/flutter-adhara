import 'package:adhara/adhara.dart';

class User extends Bean {
  static const String ID = "id";
  static const String USER_NAME = "username";
  static const String FIRST_NAME = "first_name";
  static const String LAST_NAME = "last_name";
  static const String ROLE = "role";
  static const String PROFILE_IMAGE = "image";
  static const String EMAIL = "email";
  static const String PHONE = "mobile";
  static const String PASSWORD = "password";
  static const String IS_LOGGED_IN_USER = "is_logged_in_user";

  User([data]) : super(data);

  User.system(){
    data = {
      ID: -1,
      FIRST_NAME: "System",
      ROLE: "-",
      PROFILE_IMAGE: null,
      IS_LOGGED_IN_USER: false
    };
  }

  int get id => data[ID];

  set userName(String _username) => data[USER_NAME] = _username;

  String get userName => convertToString(data[USER_NAME]);

  String get firstName => convertToString(data[FIRST_NAME], "-");

  String get lastName => convertToString(data[LAST_NAME], "-");

  set profileImage(String _image) => data[PROFILE_IMAGE] = _image;

  String get image => convertToString(data[PROFILE_IMAGE], "static/dummy.png");

  set password(String _password) => data[PASSWORD] = _password;

  set email(String _email) => data[EMAIL] = _email;

  String get email => convertToString(data[EMAIL], "-");

  String get phone => convertToString(data[PHONE], "-");

  bool get isLoggedInUser => data[IS_LOGGED_IN_USER] ?? false;

  Map<String, dynamic> toSerializableMap() {
    Map<String, dynamic> srMap = new Map<String, dynamic>.from(data);
    return srMap;
  }

  Map<String, dynamic> toNetworkSerializableMap() {
    return {
      USER_NAME: data[USER_NAME],
      PASSWORD: data[PASSWORD],
    };
  }
}
