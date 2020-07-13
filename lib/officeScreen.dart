import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfficeScreen extends StatefulWidget {
  static String id = 'office';

  @override
  _OfficeScreenState createState() => _OfficeScreenState();
}

class _OfficeScreenState extends State<OfficeScreen> {
  void initState() {
    _getUserInfo();

    super.initState();
  }

  _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String keyValue = localStorage.getString('accessKey');
    String nameValue = localStorage.getString('userName');
    int uidValue = localStorage.getInt('uId');

    print(keyValue);
    print(nameValue);
    print(uidValue);
  }

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
          appBar: AppBar(
            title: Text(" Business Planner "),
            centerTitle: true,
          ),
          body: OfficeWidget(),
      );
  }
}

class OfficeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 30),

        RaisedButton(
          onPressed: () {},
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
            child: Text('Debit', style: TextStyle(fontSize: 20)),
          ),
        ),
        SizedBox(height: 30),
        RaisedButton(
          onPressed: () {

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
            child: Text('Credit', style: TextStyle(fontSize: 20)),
          ),
        ),
        SizedBox(height: 30),

      ],
    );
  }
}









