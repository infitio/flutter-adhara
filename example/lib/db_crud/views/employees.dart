import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/i.dart';


class EmployeesView extends AdharaStatefulWidget {

  @override
  _EmployeesViewState createState() => _EmployeesViewState();

}

class _EmployeesViewState extends AdharaState<EmployeesView> {

  String get tag => "EmployeesList";
  List<Employee> employees;

  @override
  fetchData(Resources r) async {
    employees = await (r.dataInterface as CRUDDataInterface).getEmployees();
    setState((){});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Employees"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).pushNamed("/db_crud/add_new").then((_){
            fetchData(r);
          });
        },
      ),
      backgroundColor: Colors.white,
      body: (employees==null)?Container():ListView.builder(
        itemCount: employees.length,
          itemBuilder: (BuildContext context, int index){
            Employee employee = employees[index];
            return ListTile(
              title: Text(employee.name),
              subtitle: Text('Age ${employee.age} | Salary ${employee.salary}'),
            );
          },
      ),
    );
  }

}