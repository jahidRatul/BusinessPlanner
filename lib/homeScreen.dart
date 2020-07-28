import 'package:bussinesscounter/clientScreen.dart';
import 'package:bussinesscounter/employeeScreen.dart';
import 'package:bussinesscounter/officeScreen.dart';
import 'package:bussinesscounter/reportScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, OfficeScreen.id);
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
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
              child: Text('Office', style: TextStyle(fontSize: 20)),
            ),
          ),
          SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, ClientScreen.id);
            },
            textColor: Colors.white,
            padding: EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
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
          SizedBox(height: 30),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, EmployeeScreen.id);
            },
            textColor: Colors.white,
            padding: EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
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
