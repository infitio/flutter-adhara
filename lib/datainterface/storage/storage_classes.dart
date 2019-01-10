import 'dart:convert' show json;

abstract class StorageClass {
  String name;
  String type;
  bool nullable;
  bool unique;
  bool autoIncrement;
  bool primaryKey;

  StorageClass(this.name, {bool nullable, bool unique, bool primaryKey})
      : this.nullable = nullable ?? false,
        this.unique = unique ?? false,
        this.primaryKey = primaryKey ?? false;

  String get q {
    List<String> constraints = [];
    if (primaryKey) constraints.add("PRIMARY KEY");
    if (unique) constraints.add("UNIQUE");
    if (!nullable) constraints.add("NOT NULL");
    return """$name $type ${constraints.join(" ")}""".trim();
  }

  ///serializer -> data will be converted to store-able format from consumable format
  serialize(value) => value;

  ///de-serializer -> data will be converted from store-able type to consumable type
  deserialize(value) => value;
}

class IntegerColumn extends StorageClass {
  String type = "integer";

  IntegerColumn(String name, {bool nullable, bool unique, bool primaryKey})
      : super(name, nullable: nullable, unique: unique, primaryKey: primaryKey);

  serialize(value) {
    if (value == null || value is int) return value;
    return int.parse(value);
  }

  deserialize(value) {
    if (value == null || value is int) return value;
    return int.parse(value);
  }
}

class BooleanColumn extends IntegerColumn {
  BooleanColumn(String name, {bool nullable, bool unique, bool primaryKey})
      : super(name, nullable: nullable, unique: unique, primaryKey: primaryKey);

  serialize(value) {
    if (value == false || value == null || value == "") {
      return 0;
    }
    return 1;
  }

  deserialize(value) {
    return value == 1;
  }
}

class TextColumn extends StorageClass {
  String type = "text";

  TextColumn(String name, {bool nullable, bool unique, bool primaryKey})
      : super(name, nullable: nullable, unique: unique, primaryKey: primaryKey);

  serialize(value) {
    if (value != null) {
      return value.toString();
    }
    return value;
  }

  deserialize(value) {
    if (value != null) {
      return value.toString();
    }
    return value;
  }
}

class BlobColumn extends StorageClass {
  String type = "blob";

  BlobColumn(String name, {bool nullable, bool unique, bool primaryKey})
      : super(name, nullable: nullable, unique: unique, primaryKey: primaryKey);
}

class JSONColumn extends BlobColumn {
  JSONColumn(String name, {bool nullable, bool unique, bool primaryKey})
      : super(name, nullable: nullable, unique: unique, primaryKey: primaryKey);

  serialize(value) {
    if (value == null) return value;
    return json.encode(value);
  }

  deserialize(value) {
    if (value == null) return value;
    return json.decode(value);
  }
}

class ProbableJSONColumn extends JSONColumn {
  ProbableJSONColumn(String name, {bool nullable, bool unique, bool primaryKey})
      : super(name, nullable: nullable, unique: unique, primaryKey: primaryKey);

  serialize(value) {
    try {
      return json.encode(value);
    } catch (e) {
      return value;
    }
  }

  deserialize(value) {
    try {
      return json.decode(value);
    } catch (e) {
      return value;
    }
  }
}

class NumericColumn extends StorageClass {
  String type = "numeric";

  NumericColumn(String name, {bool nullable, bool unique, bool primaryKey})
      : super(name, nullable: nullable, unique: unique, primaryKey: primaryKey);
}

class DatetimeColumn extends NumericColumn {
  DatetimeColumn(String name, {bool nullable, bool unique, bool primaryKey})
      : super(name, nullable: nullable, unique: unique, primaryKey: primaryKey);
}
