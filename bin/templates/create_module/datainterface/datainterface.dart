import 'package:adhara/adhara.dart';

import 'UserStorageProvider.dart';
import 'user.dart';

//TODO change class name to "{{moduleName}}DataInterface"
class AccountsDataInterface extends DataInterface {

  //TODO configure these URLs accordingly!
  static final listURI = '/{{moduleName}}/items/';
  static final detailsURI = (id) => '/{{moduleName}}/items//$id/';

  UserStorageProvider _userStorageProvider;

  //TODO change class name to "{{moduleName}}DataInterface"
  AccountsDataInterface(AdharaModule module):  super(module);

  Future<List<User>> getItems() async {
    List<Map> _items = await networkProvider.get(listURI);
//    TODO continue from here!!! .................................................................................
  }

  fetchUser(int userId) async {
    Map<String, dynamic> user = await networkProvider.get("$usersURI$userId/");
    save(_userStorageProvider, User(user));
  }

  Future<User> getUser(int userId) async {
    if (userId == null) {
      return null;
    }
    if (userId == -1) {
      return User.system();
    }
    Map user = await _userStorageProvider.getRaw(
        where: "id=?", whereArgs: [userId]);
    if (user == null) {
      await fetchUser(userId);
      user =
      await _userStorageProvider.getRaw(where: "id=?", whereArgs: [userId]);
    }
    if (user == null) {
      print("------------------------------------------------------"
          "\n..................WARNING..............................."
          "\nNo user object exists for user id $userId. Check query.!"
          "\n--------------------------------------------------------");
      return null;
    }
    return User(user);
  }

}