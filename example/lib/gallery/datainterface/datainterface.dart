import 'package:adhara/adhara.dart';

import 'ItemStorageProvider.dart';
import 'bean/item.dart';

//TODO change class name to "{{moduleName}}DataInterface"
class GalleryDataInterface extends DataInterface {

  //TODO configure these URLs accordingly!
  static final listURI = 'gallery.json';

  ItemStorageProvider _userStorageProvider;

  //TODO change class name to "{{moduleName}}DataInterface"
  GalleryDataInterface(AdharaModule module):  super(module);

  Future<List<Item>> getGalleryImages() async {
    List _items = await networkProvider.get(listURI);
    return _items.map((_item) => Item(Map.from(_item))).toList();
  }

  Future<Item> getItem(int itemId) async {
    Map item = await _userStorageProvider.getRaw(where: "id=?", whereArgs: [itemId]);
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