import 'package:bussinesscounter/welcomeScreen.dart';
import 'package:flutter/material.dart';


class RegisterScreen extends StatefulWidget {
  static String id = 'register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  height: 100,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'Register Now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.teal),
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
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                    cursorColor: Color(0xFF9b9b9b),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.assignment_ind,
                        color: Colors.cyanAccent,
                      ),
                      hintText: 'Input Name',
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
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                    cursorColor: Color(0xFF9b9b9b),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: Colors.cyanAccent,
                      ),
                      hintText: 'Enter Mobile No',
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
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
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
                    color: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    onPressed: _isLoading ? null : _login,
                    child: Text(
                      _isLoading ? 'Updating...' : 'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    disabledColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    Navigator.pushNamed(context, WelcomeScreen.id);
  }
}
