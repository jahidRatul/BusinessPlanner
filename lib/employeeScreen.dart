import 'package:flutter/material.dart';

class EmployeeScreen extends StatelessWidget {
  static String id = 'employee';
  final empController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Business Planner "),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
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
                        'Add Employee',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo),
                      ),
                      TextField(
                        autofocus: true,
                        textAlign: TextAlign.center,
                        controller: empController,
                      ),
                      RaisedButton(
                        child: const Text('Submit',style: TextStyle(fontSize: 22,color: Colors.white),),
                        onPressed: () => Navigator.pop(context),
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
          'Add Employee',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        icon: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
