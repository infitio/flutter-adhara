import 'package:adhara/adhara.dart';

import '../bean/item.dart';

class ItemModel extends Model {
  ItemModel(Resources r) : super(r);

  String get tableName => "items";

  List<StorageClass> get fields => [
        IntegerColumn(Item.ID),
        TextColumn(Item.EMPLOYEE_NAME),
        TextColumn(Item.EMPLOYEE_SALARY, nullable: true),
        TextColumn(Item.EMPLOYEE_AGE, nullable: true),
        IntegerColumn(Item.PROFILE_IMAGE, nullable: true),
      ];
}
