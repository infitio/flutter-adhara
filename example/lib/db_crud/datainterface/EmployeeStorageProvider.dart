import 'package:adhara/adhara.dart';
import 'bean/employee.dart';


class EmployeeStorageProvider extends BeanStorageProvider{

  static const String TABLE_NAME = "employees";

  EmployeeStorageProvider(AdharaModule module) : super(module);

  get tableName => TABLE_NAME;

  List<StorageClass> get fields{
    return [
      TextColumn(Employee.EMPLOYEE_NAME),
      DoubleColumn(Employee.EMPLOYEE_SALARY, nullable: true),
      IntegerColumn(Employee.EMPLOYEE_AGE, nullable: true),
      IntegerColumn(Employee.PROFILE_IMAGE, nullable: true),
    ];
  }

}