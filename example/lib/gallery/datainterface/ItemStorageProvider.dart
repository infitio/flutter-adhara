import 'package:adhara/adhara.dart';
import 'bean/item.dart';


class ItemStorageProvider extends BeanStorageProvider{

  static const String TABLE_NAME = "item";

  ItemStorageProvider(AdharaModule module) : super(module);

  get tableName => TABLE_NAME;

  List<StorageClass> get fields{
    return [
      IntegerColumn(Item.TYPE),
      TextColumn(Item.URL)
    ];
  }

}