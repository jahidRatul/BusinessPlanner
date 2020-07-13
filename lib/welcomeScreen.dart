import 'dart:convert';
import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'registerScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String messageValidation = '';

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
            Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20,
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
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: mobileController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Number cannot be empty';
                        }
                        return null;
                      },
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
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value.isEmpty) return 'Password cannot be empty';
                        return null;
                      },
                      obscureText: true,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      cursorColor: Color(0xFF9b9b9b),
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.vpn_key, color: Colors.cyanAccent),
                        hintText: 'Input Password',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
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
                    margin: EdgeInsets.only(left: 30, top: 30, right: 30),
                    child: RaisedButton(
                      elevation: 10,
                      color: Colors.pink,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      onPressed: _login,
                      child: Text(
                        _isLoading ? 'Logging...' : 'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    messageValidation,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
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
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    // form key is for validator in textformfield
    if (_formKey.currentState.validate()) {
      setState(() {
        messageValidation = '';
        _isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

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

      //returning as text in map
      Map<String, dynamic> user = jsonDecode(response.body);
      print("success msg -> " + user['message']);

      if (user['success'] == 1) {
        prefs.setString("accessKey", user['token']);
        prefs.setString("userName", user['name']);
        prefs.setInt("uId", user['accId']);

        mobileController.clear();
        passwordController.clear();
        Navigator.pushNamed(context, HomeScreen.id);
      } else {
        setState(() {
          messageValidation = user['message'];
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
