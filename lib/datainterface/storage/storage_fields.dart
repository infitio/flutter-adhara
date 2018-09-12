import 'dart:convert' show json;
import 'package:flutter/foundation.dart';

abstract class StorageField{

  String name;
  String type;
  bool nullable;
  bool unique;
  bool autoIncrement;
  bool primaryKey;

  StorageField({
    @required this.name,
    this.nullable: false,
    this.unique: false,
    this.autoIncrement: false,
    this.primaryKey: false
  });

  String get q{
    List<String> constraints = [];
    if(primaryKey) constraints.add("PRIMARY KEY");
    if(unique) constraints.add("UNIQUE");
    if(!nullable) constraints.add("NOT NULL");
    if (autoIncrement) constraints.add("AUTOINCREMENT");
    return """$name $type $constraints""".trim();
  }

  ///serializer -> data will be converted to store-able format from consumable format
  serialize(value){
    return json.encode(value);
  }

  ///de-serializer -> data will be converted from store-able type to consumable type
  deserialize(value){
    return json.decode(value);
  }

}

class IntegerField extends StorageField{
  String type = "integer";
  IntegerField({@required String name, bool nullable, bool unique, bool autoIncrement, bool primaryKey }):
      super(name: name, nullable: nullable, unique: unique, autoIncrement: autoIncrement, primaryKey: primaryKey);
}

class BooleanField extends IntegerField{

  BooleanField({@required String name, bool nullable, bool unique, bool autoIncrement, bool primaryKey }):
      super(name: name, nullable: nullable, unique: unique, autoIncrement: autoIncrement, primaryKey: primaryKey);

  serialize(value){
    if(value==false || value==null || value==""){
      return 0;
    }
    return 1;
  }

  deserialize(value){
    return value==1;
  }

}

class TextField extends StorageField{
  String type = "text";

  TextField({@required String name, bool nullable, bool unique, bool autoIncrement, bool primaryKey }):
      super(name: name, nullable: nullable, unique: unique, autoIncrement: autoIncrement, primaryKey: primaryKey);

  serialize(value){
    if(value!=null){
      return value.toString();
    }
    return value;
  }

  deserialize(value){
    if(value!=null){
      return value.toString();
    }
    return value;
  }

}

class BlobField extends StorageField{
  String type = "blob";

  BlobField({@required String name, bool nullable, bool unique, bool autoIncrement, bool primaryKey }):
      super(name: name, nullable: nullable, unique: unique, autoIncrement: autoIncrement, primaryKey: primaryKey);

}

class JSONField extends BlobField{

  JSONField({@required String name, bool nullable, bool unique, bool autoIncrement, bool primaryKey }):
      super(name: name, nullable: nullable, unique: unique, autoIncrement: autoIncrement, primaryKey: primaryKey);

  serialize(value){
    return json.encode(value);
  }

  deserialize(value){
    return json.decode(value);
  }

}

class NumericField extends StorageField{
  String type = "numeric";

  NumericField({@required String name, bool nullable, bool unique, bool autoIncrement, bool primaryKey }):
      super(name: name, nullable: nullable, unique: unique, autoIncrement: autoIncrement, primaryKey: primaryKey);

}

class DatetimeField extends NumericField{

  DatetimeField({@required String name, bool nullable, bool unique, bool autoIncrement, bool primaryKey }):
      super(name: name, nullable: nullable, unique: unique, autoIncrement: autoIncrement, primaryKey: primaryKey);

}