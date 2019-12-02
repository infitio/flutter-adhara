import 'package:adhara/adhara.dart';
import 'builtuser.dart';
part 'user.model.g.dart';


abstract class UserModel extends Model{

  static const String TABLE_NAME = "users";
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

  BuiltUser get builtValue => BuiltUser();

  UserModel(Resources resources) : super(resources);

  get tableName => TABLE_NAME;

  List<StorageClass> get fields{
    return [
      IntegerColumn(UserModel.ID),
      TextColumn(UserModel.USER_NAME),
      TextColumn(UserModel.FIRST_NAME),
      TextColumn(UserModel.LAST_NAME, nullable: true),
      IntegerColumn(UserModel.ROLE, nullable: true),
      TextColumn(UserModel.PROFILE_IMAGE, nullable: true),
      TextColumn(UserModel.EMAIL, nullable: true),
      TextColumn(UserModel.PHONE, nullable: true),
      BooleanColumn(UserModel.IS_LOGGED_IN_USER),
    ];
  }

  toBuiltValue(){

  }

}