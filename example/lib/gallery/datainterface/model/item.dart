import 'package:adhara/adhara.dart';
import '../bean/item.dart';


class ItemModel extends Model{

  ItemModel(Resources r): super(r);

  String get tableName => "items";
  List<StorageClass> get fields => [
    IntegerColumn(Item.TYPE),
    TextColumn(Item.URL)
  ];

}