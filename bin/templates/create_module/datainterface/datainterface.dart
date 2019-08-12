import 'package:adhara/adhara.dart';

import 'ItemStorageProvider.dart';
import 'bean/item.dart';

//TODO change class name to "{{moduleName}}DataInterface"
class AccountsDataInterface extends DataInterface {

  //TODO configure these URLs accordingly!
  static final listURI = '/{{moduleName}}/items/';
  static final detailsURI = (id) => '/{{moduleName}}/items//$id/';

  ItemStorageProvider _userStorageProvider;

  //TODO change class name to "{{moduleName}}DataInterface"
  AccountsDataInterface(AdharaModule module):  super(module);

  Future<List<Item>> getItems() async {
    List<Map> _items = await networkProvider.get(listURI);
    return _items.map((Map _item) => Item(_item)).toList();
  }

  fetchItem(int itemId) async {
    Map<String, dynamic> user = await networkProvider.get(detailsURI(itemId));
    save(_userStorageProvider, Item(user));
  }

  Future<Item> getItem(int itemId) async {
    Map item = await _userStorageProvider.getRaw(where: "id=?", whereArgs: [itemId]);
    if (item == null) {
      await fetchItem(itemId);
      item = await _userStorageProvider.getRaw(where: "id=?", whereArgs: [itemId]);
    }
    if (item == null) {
      print("------------------------------------------------------"
          "\n..................WARNING..............................."
          "\nNo item object exists for user id $itemId. Check query.!"
          "\n--------------------------------------------------------");
      return null;
    }
    return Item(item);
  }

}