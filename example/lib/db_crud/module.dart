import 'package:adhara/adhara.dart';

import 'views/employees.dart';
import 'views/newemployee.dart';
import 'datainterface/i.dart';


class DBCurdModule extends AdharaModule{

  String name = "db_crud";

  List<URL> get urls => [
    URL("/employees", widget: EmployeesView()),
    URL("/add_new", widget: AddNewEmployeeView()),
  ];

  String i18nResourceBundle = 'assets/i18n';

  DataInterface get dataInterface => CRUDDataInterface(this);

}
