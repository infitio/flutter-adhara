import 'package:adhara/datainterface/models/base.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/src/exception.dart' show SqfliteDatabaseException;


class MigrationManager{

  String _createQuery(Model model) {
    return model.fields.map((_f) => _f.q).join(", ");
  }

  Future createTable(Database db, Model model) async {
    try {
      await db.execute("create table ${model.tableName} (${_createQuery(model)});");
    } on SqfliteDatabaseException catch (e) {
      if (e.getResultCode() != 1) {
        if (e.toString().indexOf("already exists") == -1) {
          throw e;
        }
      }
    }
  }

}
