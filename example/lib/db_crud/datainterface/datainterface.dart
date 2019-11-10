import 'package:adhara/adhara.dart';

import 'EmployeeStorageProvider.dart';
import 'bean/employee.dart';

class CRUDDataInterface extends DataInterface {

  EmployeeStorageProvider _employeeStorageProvider;

  CRUDDataInterface(AdharaModule module):
        _employeeStorageProvider = EmployeeStorageProvider(module),
        super(module);

  List<StorageProvider> get dataStores => [
    _employeeStorageProvider
  ];

  Future<List<Employee>> getEmployees() async {
    List<Map> _items = await _employeeStorageProvider.getList();
    return _items?.map((Map _item) => Employee(_item))?.toList();
  }

  Future<Employee> createEmployee(Employee employee) async {
    return await _employeeStorageProvider.insertBean(employee);
  }

}