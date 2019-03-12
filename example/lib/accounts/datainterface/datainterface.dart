import 'package:adhara/adhara.dart';

import 'UserStorageProvider.dart';
import 'user.dart';

class AccountsDataInterface extends DataInterface {

  static final loginURI = '/login';
  static final logoutURI = '/logout';
  static final usersURI = '/users/';

  UserStorageProvider _userStorageProvider;

  AccountsDataInterface(AdharaModule module):  super(module);

  storeUserDetails(int userId, String userAccessToken, String env) {
    r.preferences.setInt("user_id", userId);
    r.preferences.setString("access_token", userAccessToken);
    r.preferences.setString("env", env);
  }

  removeUserDetails() {
    r.preferences.remove("user_id");
    r.preferences.remove("access_token");
    r.preferences.remove("env");
  }

  String getUserAccessToken() => r.preferences.getString("access_token");

  int getLoggedInUserId() => r.preferences.getInt("user_id");

  Future<User> login(User user) async {
    Map _userMap = user.toNetworkSerializableMap();
//    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//    _userMap['firebase_token'] = await _firebaseMessaging.getToken();
    Map _user = await this.networkProvider.post(loginURI, _userMap);
    int userId = _user[User.ID];
    String _userAccessToken = _user["token"];
    storeUserDetails(userId, _userAccessToken, _user["env"]);
    //handle setting user detail to network provider for authentication...
    return this.getLoggedInUser();
  }

  bool isLoggedIn() {
    String _userAccessToken = getUserAccessToken();
    if (_userAccessToken == null) {
      return false;
    } else {
      //handle setting user detail to network provider for authentication...
      return true;
    }
  }

  Future networkLogout() async {
    await (r.dataInterface as AccountsDataInterface).networkProvider.post(logoutURI, {});
    this.logout();
  }

  logout() {
    removeUserDetails();
  }

  Future<User> getLoggedInUser() async {
    if (isLoggedIn()) {
      return getUser(getLoggedInUserId());
    }
    return null;
  }

  Future<List<User>> getUsers() async {
    List<User> _cachedUsers = r.appState.getScope("db-cache").getValue(
        "users", null);
    if (_cachedUsers != null) {
      return _cachedUsers;
    }
    List<Map> users = await super.query(_userStorageProvider, orderBy: User.ID);
    List<User> _users = [];
    for (int i = 0; i < users.length; i++) {
      _users.add(User(users[i]));
    }
    r.appState.getScope("db-cache").setValue("users", _users);
    return _users;
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