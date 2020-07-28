import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllTransactionReport extends StatefulWidget {
  static String id = 'allTransReport';

  @override
  _AllTransactionReportState createState() => _AllTransactionReportState();
}

enum TransactionType { debit, credit }

class _AllTransactionReportState extends State<AllTransactionReport> {
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

    final url = 'http://192.168.0.117:5000/api/reports/report/transactions/all';

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
//    print(jsonData);
    List<Client> clients = [];
    for (var i in jsonData) {
      Client client = Client(
        i["name"],
        i["id"],
        i["uId"],
        i["pid"],
        i["amount"],
        i["tType"],
        i["tTime"],
        i["note"],
        i["type"],
      );
      clients.add(client);
    }
    print(clients.length);
    return clients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Business Planner "),
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
                      leading: Column(
                        children: <Widget>[
                          CircleAvatar(
                            child: Text(snapshot.data[index].pid.toString()),
                          ),
                          Text(snapshot.data[index].type),
                        ],
                      ),
                      isThreeLine: true,
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].tTime +
                          " " +
                          snapshot.data[index].note),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(snapshot.data[index].tType),
                          Text('tk:' + snapshot.data[index].amount.toString()),
                        ],
                      ),
                    );
                  });
          },
        ),
      ),
    );
  }
}

class Client {
  final String name;
  final int id;
  final int uId;
  final int pid;
  final int amount;
  final String type;
  final String tType;
  final String tTime;
  final String note;

  Client(
    this.name,
    this.id,
    this.uId,
    this.pid,
    this.amount,
    this.tType,
    this.tTime,
    this.note,
    this.type,
  );
}
