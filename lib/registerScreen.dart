import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bussinesscounter/welcomeScreen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String messageValidation = '';

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

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
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      cursorColor: Color(0xFF9b9b9b),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.assignment_ind,
                          color: Colors.cyanAccent,
                        ),
                        hintText: 'Input Name',
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
                    margin: const EdgeInsets.only(left: 30, top: 30, right: 30),
                    child: RaisedButton(
                      elevation: 10,
                      color: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      onPressed: _register,
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
            ),
          ],
        ),
      ),
    );
  }

  void _register() async {
    // form key is for validator in textformfield
    if (_formKey.currentState.validate()) {
      setState(() {
        messageValidation = '';
        _isLoading = true;
      });

      // final url = 'http://10.0.2.2:5000/api/users/register';

      // if (device + local server) thn should be ip_address:5000 instead of localhost:5000
      final url = 'http://192.168.0.141:5000/api/users/register';

      Map data = {
        'name': nameController.text,
        'mobileno': mobileController.text,
        'password': passwordController.text
      };
      //encode Map to JSON
      var bodyValue = json.encode(data);

      http.Response response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: bodyValue);

      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body);
      print("success msg -> " + user['message']);

      Navigator.pushNamed(context, WelcomeScreen.id);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
