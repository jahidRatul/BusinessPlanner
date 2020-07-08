import 'dart:convert';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'registerScreen.dart';
import 'package:http/http.dart' as http;

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/businessLogo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListView(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  child: Text(
                    'Focus Productivity & Business Well..\n Welcome to Business Planner ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.blueGrey),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(left: 30, top: 30, right: 30),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                  child: TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                    cursorColor: Color(0xFF9b9b9b),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: Colors.cyanAccent,
                      ),
                      hintText: 'Input Mobile Number',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(left: 30, top: 30, right: 30),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                    cursorColor: Color(0xFF9b9b9b),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key, color: Colors.cyanAccent),
                      hintText: 'Input Password',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 30, top: 30, right: 30),
                  child: RaisedButton(
                    elevation: 10,
                    color: Colors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    onPressed: _isLoading ? null : _login,
                    child: Text(
                      _isLoading ? 'Logging...' : 'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    disabledColor: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Don\'t have account? ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreen.id);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 17),
                      ),
                      textColor: Colors.indigo,
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // if (android emulator + local server) thn should be 10.0.2.2:5000 instead of localhost:5000
    final url = 'http://10.0.2.2:5000/api/users/login';

    Map data = {
      'mobileno': mobileController.text,
      'password': passwordController.text
    };

    //encode Map to JSON
    var bodyValue = json.encode(data);

    http.Response response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: bodyValue);

    print(response.body);

    //returning as text
    Map<String, dynamic> user = jsonDecode(response.body);
    print("access token -> " + user['token']);
    print("accId -> " + user['accId'].toString());
    print("name -> " + user['name']);

    Navigator.pushNamed(context, HomeScreen.id);

    setState(() {
      _isLoading = false;
    });
  }
}
