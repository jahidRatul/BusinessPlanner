import 'dart:convert';
import 'package:bussinesscounter/employeeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'homeScreen.dart';

enum TransactionType { debit, credit }
var userKey;
var userId;

class EmpTransPage extends StatefulWidget {
  final Employee emp;

  EmpTransPage(this.emp);

  @override
  _EmpTransPageState createState() => _EmpTransPageState();
}

class _EmpTransPageState extends State<EmpTransPage> {
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void initState() {
    _getUserInfo();

    super.initState();
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TransactionType tValue = TransactionType.debit;

  _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String keyValue = localStorage.getString('accessKey');
    String nameValue = localStorage.getString('userName');
    int uidValue = localStorage.getInt('uId');
    userKey = keyValue;
    userId = uidValue;

//    print(keyValue);
//    print(nameValue);
//    print(uidValue);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.emp.name),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, EmployeeScreen.id);
              }),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Debit'),
                leading: Radio(
                  value: TransactionType.debit,
                  groupValue: tValue,
                  onChanged: (TransactionType value) {
                    setState(() {
                      tValue = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Credit'),
                leading: Radio(
                  value: TransactionType.credit,
                  groupValue: tValue,
                  onChanged: (TransactionType value) {
                    setState(() {
                      tValue = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 70),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  decoration: InputDecoration(
                    hintText: 'amount',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 70),
                child: TextField(
                  maxLines: 3,
                  controller: noteController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Note',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 25),
                child: RaisedButton(
                  onPressed: _completeTransaction,
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 17),
                  ),
                  textColor: Colors.indigo,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _completeTransaction() async {
    if (amountController.text.isNotEmpty) {
      if (tValue == TransactionType.debit) {
//        final url =
//            'http://10.0.2.2:5000/api/employees/employee/debit/${widget.emp.id}';

        final url = callApi + '/employees/employee/debit/${widget.emp.id}';

        Map data = {
          'amount': amountController.text,
          'note': noteController.text,
          'uId': userId
        };
        //encode Map to JSON
        var bodyValue = json.encode(data);

        http.Response response = await http.post(url,
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $userKey'
            },
            body: bodyValue);

//        print(response.body);
        //returning as text in map
        Map<String, dynamic> user = jsonDecode(response.body);
//        print("success msg -> " + user['message']);
        amountController.clear();
        noteController.clear();
        Navigator.pushReplacementNamed(context, EmployeeScreen.id);
      } else {
//        final url =
//            'http://10.0.2.2:5000/api/employees/employee/credit/${widget.emp.id}';
        final url = callApi + '/employees/employee/credit/${widget.emp.id}';

        Map data = {
          'amount': amountController.text,
          'note': noteController.text,
          'uId': userId
        };
        //encode Map to JSON
        var bodyValue = json.encode(data);

        http.Response response = await http.post(url,
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $userKey'
            },
            body: bodyValue);

//        print(response.body);
        //returning as text in map
        Map<String, dynamic> user = jsonDecode(response.body);
//        print("success msg -> " + user['message']);
        amountController.clear();
        noteController.clear();
        Navigator.pushReplacementNamed(context, EmployeeScreen.id);
      }
    }
  }
}

class Employee {
  final String name;
  final int id;
  Employee(this.name, this.id);
}
