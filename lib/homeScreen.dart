import 'dart:convert';

import 'package:bussinesscounter/welcomeScreen.dart';
import 'package:intl/intl.dart';
import 'package:bussinesscounter/clientScreen.dart';
import 'package:bussinesscounter/employeeScreen.dart';
import 'package:bussinesscounter/officeScreen.dart';
import 'package:bussinesscounter/reports/reportScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var ofcAmount;
var clientAmount;
var empAmount;
var adminBalance;

class _HomeScreenState extends State<HomeScreen> {
  var userKey;
  var userId;
  var userName;

  void initState() {
    _getUserInfo();

    super.initState();
  }

  _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String keyValue = localStorage.getString('accessKey');
    String nameValue = localStorage.getString('userName');
    int uidValue = localStorage.getInt('uId');

//    print('keyVal ->' + keyValue);
//    print('nameVal ->' + nameValue);
//    print('accId ->' + uidValue.toString());
    userName = nameValue;
    userKey = keyValue;
    userId = uidValue;
    setState(() {
      _getBalance();
      _getAdminBalance();
    });
  }

  Future _getAdminBalance() async {
    final url = callApi + '/reports/report/transactions/adminBalance';

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
      adminBalance = jsonData[0]['balance'];
    });
  }

  Future _getBalance() async {
//    final url = 'http://10.0.2.2:5000/api/clients/client';

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
      ofcAmount = jsonData[0]['ofc'];
      clientAmount = jsonData[0]['client'];
      empAmount = jsonData[0]['emp'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.account_circle,
          size: 45,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$userName',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            Text(
              "$adminBalance",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
          child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              '$userName',
              style: TextStyle(color: Colors.white, fontSize: 22.0),
            ),
            currentAccountPicture: CircleAvatar(
              child: FlutterLogo(size: 40),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('accessKey');
              prefs.remove('userName');
              prefs.remove('uId');
              Navigator.pushReplacementNamed(context, WelcomeScreen.id);
            },
          ),
        ],
      )),
      body: AdminWidget(),
    );
  }
}

class AdminWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, OfficeScreen.id);
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Office',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListTile(
                    title: Text(
                      'Balance',
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      '$ofcAmount',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ClientScreen.id);
                },
                textColor: Colors.white,
                padding: EdgeInsets.all(15.0),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(15.0),
                  child: Text('Client', style: TextStyle(fontSize: 20)),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListTile(
                    title: Text(
                      'Balance',
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      clientAmount.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, EmployeeScreen.id);
                },
                textColor: Colors.white,
                padding: EdgeInsets.all(15.0),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(15.0),
                  child: Text('Employee', style: TextStyle(fontSize: 20)),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListTile(
                    title: Text(
                      'Balance',
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      empAmount.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, ReportScreen.id);
            },
            textColor: Colors.white,
            padding: EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFFc70039),
                    Color(0xFFf37121),
                    Color(0xFFffbd69),
                  ],
                ),
              ),
              padding: EdgeInsets.all(15.0),
              child: Center(
                  child: Text('Reports', style: TextStyle(fontSize: 20))),
            ),
          ),
        ],
      ),
    );
  }
}
