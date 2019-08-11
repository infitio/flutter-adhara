import 'package:adhara/adhara.dart';
import 'user.dart';


class UserStorageProvider extends BeanStorageProvider{

  static const String TABLE_NAME = "users";

  UserStorageProvider(AdharaModule module) : super(module);

  get tableName => TABLE_NAME;

  List<StorageClass> get fields{
    return [
      IntegerColumn(User.ID),
      TextColumn(User.USER_NAME),
      TextColumn(User.FIRST_NAME),
      TextColumn(User.LAST_NAME, nullable: true),
      IntegerColumn(User.ROLE, nullable: true),
      TextColumn(User.PROFILE_IMAGE, nullable: true),
      TextColumn(User.EMAIL, nullable: true),
      TextColumn(User.PHONE, nullable: true),
      BooleanColumn(User.IS_LOGGED_IN_USER),
    ];
  }

}