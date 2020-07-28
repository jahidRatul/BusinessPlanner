import 'package:bussinesscounter/clientScreen.dart';
import 'package:bussinesscounter/employeeScreen.dart';
import 'package:bussinesscounter/officeScreen.dart';
import 'package:bussinesscounter/reportScreen.dart';
import 'package:bussinesscounter/reports/allTransactionReport.dart';
import 'package:flutter/material.dart';
import 'welcomeScreen.dart';
import 'homeScreen.dart';
import 'registerScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Planner',
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        OfficeScreen.id: (context) => OfficeScreen(),
        ClientScreen.id: (context) => ClientScreen(),
        EmployeeScreen.id: (context) => EmployeeScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ReportScreen.id: (context) => ReportScreen(),
        AllTransactionReport.id: (context) => AllTransactionReport()
      },
    );
  }
}
