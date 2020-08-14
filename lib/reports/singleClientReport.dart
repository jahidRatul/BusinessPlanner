import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bussinesscounter/constants.dart';

class SingleClientReport extends StatefulWidget {
  static String id = 'singleClientReport';
  final Person client;

  SingleClientReport(this.client);

  @override
  _SingleClientReportState createState() => _SingleClientReportState();
}

enum TransactionType { debit, credit }
var totalDebit;
var totalCredit;
var balance;
var countPerson;

class _SingleClientReportState extends State<SingleClientReport> {
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
      _getSummery();
    });
  }

  Future<List<Person>> _getPerson() async {
//    final url = 'http://10.0.2.2:5000/api/clients/client';

    final url = callApi + '/reports/report/transactions/singleClient';

    Map data = {'uId': userId, 'id': widget.client.id};
    //encode Map to JSON
    var bodyValue = json.encode(data);

    http.Response response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $userKey',
      },
      body: bodyValue,
    );
    var jsonData = json.decode(response.body);
//    print(jsonData);
    List<Person> persons = [];
    for (var i in jsonData) {
      Person person = Person(
        i["name"],
        i["id"],
        i["uId"],
        i["pid"],
        i["amount"],
        i["tType"],
        i["tTime"],
        i["note"],
        i["type"],
      );
      persons.add(person);
    }
    countPerson = persons.length;

    return persons;
  }

  Future _getSummery() async {
//    final url = 'http://10.0.2.2:5000/api/clients/client';

    final url = callApi + '/reports/report/transactions/singleClientSummary';

    Map data = {'uId': userId, 'id': widget.client.id};
    //encode Map to JSON
    var bodyValue = json.encode(data);

    http.Response response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $userKey',
      },
      body: bodyValue,
    );
    var jsonData = json.decode(response.body);

    setState(() {
      totalDebit = jsonData[0]['total_debit'];
      totalCredit = jsonData[0]['total_credit'];
      balance = jsonData[0]['balance'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client.name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
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
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38)),
                              child: ListTile(
                                leading: Column(
                                  children: <Widget>[
                                    CircleAvatar(
                                      child: Text(
                                          snapshot.data[index].pid.toString()),
                                    ),
                                    Text(snapshot.data[index].type),
                                  ],
                                ),
                                isThreeLine: true,
                                title: Text(snapshot.data[index].name),
                                subtitle: Text(snapshot.data[index].tTime +
                                    "\n" +
                                    snapshot.data[index].note),
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(snapshot.data[index].tType),
                                    Text('tk:' +
                                        snapshot.data[index].amount.toString()),
                                  ],
                                ),
                              ),
                            );
                          });
                  },
                ),
              ),
              Material(
                  color: Colors.white,
                  child: Container(
                    height: 80,
                    padding: EdgeInsets.all(5),
                    child: Table(
                      border: TableBorder.all(color: Colors.teal),
                      children: [
                        TableRow(children: [
                          TableCell(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Transactions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'times: ' + countPerson.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TableCell(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Total Debit',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'tk: ' + totalDebit.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TableCell(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Total Credit',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('tk: ' + totalCredit.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          TableCell(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Balance',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('tk: ' + balance.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),

//                          Text('Balance'),
                        ]),
//                        TableRow(children: [
//                          Text('Cell 4'),
//                          Text('Cell 5'),
//                          Text('Cell 5'),
//                        ])
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class Person {
  final String name;
  final int id;
  final int uId;
  final int pid;
  final int amount;
  final String type;
  final String tType;
  final String tTime;
  final String note;

  Person(
    this.name,
    this.id,
    this.uId,
    this.pid,
    this.amount,
    this.tType,
    this.tTime,
    this.note,
    this.type,
  );
}
