import 'package:adhara/adhara.dart';
import '../bean/employee.dart';


class EmployeeModel extends Model{

  EmployeeModel(Resources r): super(r);

  String get tableName => "employee";
  List<StorageClass> get fields => [
    TextColumn(Employee.EMPLOYEE_NAME),
    DoubleColumn(Employee.EMPLOYEE_SALARY, nullable: true),
    TextColumn(Employee.EMPLOYEE_AGE, nullable: true),
    IntegerColumn(Employee.PROFILE_IMAGE, nullable: true),
  ];

}