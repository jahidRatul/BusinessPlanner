import 'dart:convert';

import 'package:bussinesscounter/reports/allTransactionReport.dart';
import 'package:bussinesscounter/reports/clientReport.dart';
import 'package:bussinesscounter/reports/employeeReport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class ReportScreen extends StatefulWidget {
  static String id = 'report';
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

var ofcBalanceTotal, ofcDebitTotal, ofcCreditTotal;
var clientBalanceTotal, clientDebitTotal, clientCreditTotal;
var empBalanceTotal, empDebitTotal, empCreditTotal;

class _ReportScreenState extends State<ReportScreen> {
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

    print('keyVal ->' + keyValue);
    print('nameVal ->' + nameValue);
    print('accId ->' + uidValue.toString());
    userKey = keyValue;
    userId = uidValue;
    setState(() {
      _getBalance();
    });
  }

  Future _getBalance() async {
    final url =
        callApi + '/reports/report/transactions/currentBalanceIndividual';

    Map data = {'uId': userId};
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
    print(jsonData);
    setState(() {
      ofcBalanceTotal = jsonData[0]['ofc'];
      ofcCreditTotal = jsonData[0]['ofcCredit'];
      ofcDebitTotal = jsonData[0]['ofcDebit'];
      clientBalanceTotal = jsonData[0]['client'];
      clientCreditTotal = jsonData[0]['clientCredit'];
      clientDebitTotal = jsonData[0]['clientDebit'];
      empBalanceTotal = jsonData[0]['emp'];
      empCreditTotal = jsonData[0]['empCredit'];
      empDebitTotal = jsonData[0]['empDebit'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Business Planner "),
        centerTitle: true,
      ),
      body: ReportWidget(),
    );
  }
}

class ReportWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SummaryWidget(
              title: 'Office',
              balance: ofcBalanceTotal,
              tCredit: ofcCreditTotal,
              tDebit: ofcDebitTotal),
          SummaryWidget(
              title: 'Clients',
              balance: clientBalanceTotal,
              tCredit: clientCreditTotal,
              tDebit: clientDebitTotal),
          SummaryWidget(
              title: 'Employees',
              balance: empBalanceTotal,
              tCredit: empCreditTotal,
              tDebit: empDebitTotal),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                onPressed: () {},
                color: Colors.red,
                textColor: Colors.white,
                child: Text("Office".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                onPressed: () {
                  Navigator.pushNamed(context, ClientReport.id);
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text("Client".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                onPressed: () {
                  Navigator.pushNamed(context, EmployeeReport.id);
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text("Employee".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
              color: Colors.white,
              textColor: Colors.red,
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                Navigator.pushNamed(context, AllTransactionReport.id);
              },
              child: Text(
                "all transactions".toUpperCase(),
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryWidget extends StatelessWidget {
  final String title;
  final int tDebit;
  final int tCredit;
  final int balance;

  SummaryWidget({this.title, this.tDebit, this.tCredit, this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.indigo,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.white,
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
                            'Total Debit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'tk: ' + tDebit.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                          child: Text('tk: ' + tCredit.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
