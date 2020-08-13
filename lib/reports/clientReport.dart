import 'dart:convert';
import 'package:bussinesscounter/reports/singleClientReport.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ClientReport extends StatefulWidget {
  static String id = 'clientReport';

  @override
  _ClientReportState createState() => _ClientReportState();
}

enum TransactionType { debit, credit }

class _ClientReportState extends State<ClientReport> {
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

//    print(keyValue);
//    print(nameValue);
//    print(uidValue);
    setState(() {
      _getClient();
    });
  }

  Future<List<Client>> _getClient() async {
//    final url = 'http://10.0.2.2:5000/api/clients/client';

    final url = callApi + '/clients/client/user=$userId';

    http.Response response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $userKey',
      },
    );
    var jsonData = json.decode(response.body);
//    print(jsonData);
    List<Client> clients = [];
    for (var i in jsonData) {
      Client client = Client(i["name"], i["id"], i["uId"], i["pid"],
          i["amount"], i["type"], i["tType"], i["tTime"], i["note"]);
      clients.add(client);
    }
//    print(clients.length);
    return clients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Clients Report "),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getClient(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(child: Text('Loading...')),
              );
            } else
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(snapshot.data[index].id.toString()),
                      ),
                      title: Text(snapshot.data[index].name),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SingleClientReport(snapshot.data[index])));
                      },
                    );
                  });
          },
        ),
      ),
    );
  }
}
