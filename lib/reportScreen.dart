import 'package:bussinesscounter/clientScreen.dart';
import 'package:bussinesscounter/employeeScreen.dart';
import 'package:bussinesscounter/officeScreen.dart';
import 'package:bussinesscounter/reports/allTransactionReport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportScreen extends StatefulWidget {
  static String id = 'report';
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
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
          SizedBox(width: 10),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)),
            onPressed: () {},
            color: Colors.red,
            textColor: Colors.white,
            child:
                Text("Buy now".toUpperCase(), style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
