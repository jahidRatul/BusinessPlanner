import 'dart:convert';
import 'package:bussinesscounter/clientScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum TransactionType { debit, credit }
var userKey;
var userId;

class ClientTransPage extends StatefulWidget {
  final Client client;

  ClientTransPage(this.client);

  @override
  _ClientTransPageState createState() => _ClientTransPageState();
}

class _ClientTransPageState extends State<ClientTransPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.client.name),
        centerTitle: true,
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
    );
  }

  _completeTransaction() async {
    if (amountController.text.isNotEmpty) {
      if (tValue == TransactionType.debit) {
//        final url =
//            'http://10.0.2.2:5000/api/clients/client/debit/${widget.client.id}';

        final url =
            'http://192.168.0.117:5000/api/clients/client/debit/${widget.client.id}';

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
        Navigator.pushNamed(context, ClientScreen.id);
      } else {
//        final url =
//            'http://10.0.2.2:5000/api/clients/client/credit/${widget.client.id}';
        final url =
            'http://192.168.0.117:5000/api/clients/client/credit/${widget.client.id}';
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
        Navigator.pushNamed(context, ClientScreen.id);
      }
    }
  }
}

class Client {
  final String name;
  final int id;
  Client(this.name, this.id);
}
