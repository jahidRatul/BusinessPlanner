import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ClientScreen extends StatefulWidget {
  static String id = 'client';

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  TextEditingController clientController = TextEditingController();
  var userKey;
  var userId;

  @override
  void dispose() {
    clientController.dispose();
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

    print(keyValue);
    print(nameValue);
    print(uidValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Business Planner "),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Colors.white70,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        'Add Client',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo),
                      ),
                      TextField(
                        autofocus: true,
                        textAlign: TextAlign.center,
                        controller: clientController,
                      ),
                      RaisedButton(
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                        onPressed: _addClient,
                        color: Colors.indigo,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        label: Text(
          'Add Client',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        icon: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  _addClient() async {
    final url = 'http://10.0.2.2:5000/api/clients/client';

    if (clientController.text.isNotEmpty) {
      Map data = {'name': clientController.text, 'uId': userId};
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
      clientController.clear();
      Navigator.pop(context);
    }
  }
}
