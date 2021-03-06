import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homeScreen.dart';
import 'constants.dart';

class OfficeScreen extends StatefulWidget {
  static String id = 'office';

  @override
  _OfficeScreenState createState() => _OfficeScreenState();
}

enum TransactionType { debit, credit }

class _OfficeScreenState extends State<OfficeScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  var userKey;
  var userId;

  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

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
  }

  TransactionType tValue = TransactionType.debit;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(" Business Planner "),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, HomeScreen.id);
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
        // final url = 'http://10.0.2.2:5000/api/office/debit';

        // if (device + local server) thn should be ip_address:5000 instead of localhost:5000
        final url = callApi + '/office/debit';

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

        print(response.body);
        //returning as text in map
        Map<String, dynamic> user = jsonDecode(response.body);
        print("success msg -> " + user['message']);
        amountController.clear();
        noteController.clear();
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      } else {
//        final url = 'http://10.0.2.2:5000/api/office/credit';

        // if (device + local server) thn should be ip_address:5000 instead of localhost:5000
        final url = callApi + '/office/credit';
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

        print(response.body);
        //returning as text in map
        Map<String, dynamic> user = jsonDecode(response.body);
        print("success msg -> " + user['message']);
        amountController.clear();
        noteController.clear();
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    }
  }
}
