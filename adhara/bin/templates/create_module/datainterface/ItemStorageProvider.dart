import 'package:adhara/adhara.dart';

import 'bean/item.dart';

class ItemStorageProvider extends BeanStorageProvider {
  static const String TABLE_NAME = "item";

  ItemStorageProvider(AdharaModule module) : super(module);

  get tableName => TABLE_NAME;

  List<StorageClass> get fields {
    return [
      IntegerColumn(Item.ID),
      TextColumn(Item.EMPLOYEE_NAME),
      TextColumn(Item.EMPLOYEE_SALARY, nullable: true),
      TextColumn(Item.EMPLOYEE_AGE, nullable: true),
      IntegerColumn(Item.PROFILE_IMAGE, nullable: true),
    ];
  }
}
