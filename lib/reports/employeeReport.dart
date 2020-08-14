import 'dart:convert';
import 'package:bussinesscounter/reports/singleEmployeeReport.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class EmployeeReport extends StatefulWidget {
  static String id = 'empReport';

  @override
  _EmployeeReportState createState() => _EmployeeReportState();
}

enum TransactionType { debit, credit }

class _EmployeeReportState extends State<EmployeeReport> {
  var userKey;
  var userId;

  void initState() {
    _getUserInfo();

    super.initState();
  }

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
    setState(() {
      _getPerson();
    });
  }

  Future<List<Person>> _getPerson() async {
//    final url = 'http://10.0.2.2:5000/api/clients/client';

    final url = callApi + '/employees/employee/user=$userId';

    http.Response response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $userKey',
      },
    );
    var jsonData = json.decode(response.body);
//    print(jsonData);
    List<Person> persons = [];
    for (var i in jsonData) {
      Person person = Person(i["name"], i["id"], i["uId"], i["pid"],
          i["amount"], i["type"], i["tType"], i["tTime"], i["note"]);
      persons.add(person);
    }
//    print(persons.length);
    return persons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Employees Report "),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getPerson(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(child: Text('Loading...')),
              );
            } else
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(snapshot.data[index].id.toString()),
                      ),
                      title: Text(snapshot.data[index].name),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleEmployeeReport(
                                    snapshot.data[index])));
                      },
                    );
                  });
          },
        ),
      ),
    );
  }
}
