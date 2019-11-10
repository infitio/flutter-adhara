import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import '../datainterface/i.dart';


class AddNewEmployeeView extends AdharaStatefulWidget {

  @override
  _AddNewEmployeeViewState createState() => _AddNewEmployeeViewState();

}

class _AddNewEmployeeViewState extends AdharaState<AddNewEmployeeView> {

  String get tag => "EmployeesList";
  List<Employee> employees;
  final _formKey = GlobalKey<FormState>();
  Employee employee = Employee();

  @override
  fetchData(Resources r) async {
    employees = await (r.dataInterface as CRUDDataInterface).getEmployees();
    setState((){});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Employee"),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: <Widget>[
              Text("Name"),
              TextFormField(
                validator: (value) => (value.isEmpty)?'Enter name':null,
                onChanged: (String value) => employee.name = value,
              ),
              Text("Salary"),
              TextFormField(
                validator: (value) => (value.isEmpty)?'Enter salary':null,
                onChanged: (String value) => employee.salary = double.parse(value),
                keyboardType: TextInputType.number,
              ),
              Text("Age"),
              TextFormField(
                validator: (value) => (value.isEmpty)?'Enter age':null,
                onChanged: (String value) => employee.age = int.parse(value),
                keyboardType: TextInputType.number,
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    employee = await (r.dataInterface as CRUDDataInterface).createEmployee(employee);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}