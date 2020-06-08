
import 'package:flutter/material.dart';
import 'homeScreen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;
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
                  height: 150,
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  child: Text(
                    'Focus Productivity & Business Well..\n Welcome to Business Planner ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey),
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
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    cursorColor: Color(0xFF9b9b9b),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: Colors.cyanAccent,
                      ),
                      hintText: 'Enter Phone No',
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
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    cursorColor: Color(0xFF9b9b9b),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key, color: Colors.cyanAccent),
                      hintText: 'Enter Password',
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
                    color: Colors.pinkAccent,
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
                  height: 80,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    Navigator.pushNamed(context, HomeScreen.id);
  }
}