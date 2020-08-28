import 'package:apicallslegend/models/login_response.dart';
import 'package:apicallslegend/models/user.dart';
import 'package:apicallslegend/providers/LoginProvider.dart';
import 'package:apicallslegend/view/init/InitializeProviderDataScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apicallslegend/utils/commons.dart';
import 'package:apicallslegend/utils/shape/bezierContainer.dart';
import 'package:apicallslegend/view/login/register.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authFirebase = FirebaseAuth.instance;
  bool _obscureText = true;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  TextEditingController _userEmail;
  TextEditingController _userPassword;
  final _formPageKey = GlobalKey<FormState>();
  final _pageKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _userEmail = TextEditingController(text: "");
    _userPassword = TextEditingController(text: "");
  }

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _pageKey,
        body: Form(
            key: _formPageKey,
            child: SingleChildScrollView(
                child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "API Calls Legend",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto'),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        _loginButton(),
                        _forgotPassword(),
                        SizedBox(
                          height: 20,
                        ),
                        _skipButton(),
                        _divider(),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _createAccountLabel(),
                  ),
                  // Positioned(
                  //     top: MediaQuery.of(context).size.height * .24,
                  //     left: -MediaQuery.of(context).size.width * .24,
                  //     child: BezierContainer())
                ],
              ),
            ))));
  }

  Widget _loginButton() {
    return isLoading
        ? Center(
            child: Commons.chuckyLoading("Loggin in..."),
          )
        : GestureDetector(
            onTap: () async {
              if (_formPageKey.currentState.validate()) {
                setState(() {
                  isLoading = true;
                });
                try {
                  String email = _userEmail.text;
                  String password = _userPassword.text;

                  final newUser =
                      Provider.of<LoginProvider>(context, listen: false)
                          .loginUser(email, password);
                  print(newUser.toString());
                  // if (newUser != null) {
                  //   _loginWithPhoneAndPassword(email, password);
                  // }

                  if (newUser.then((value) => value.user) != null) {
                    User myUser;
                    newUser.then((value) {
                      myUser = value.user;
                    });
                    _loginWithPhoneAndPassword(myUser);
                  }
                } catch (e) {
                  Commons.showError(context, e.message);
                  setState(() => isLoading = false);
                  _pageKey.currentState.showSnackBar(
                      SnackBar(content: Text("Could not login.")));
                }
              }
            },
            child: Container(
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Commons.gradientBackgroundColorStart,
                        Commons.gradientBackgroundColorEnd
                      ])),
            ),
          );
  }

  Widget _forgotPassword() {
    return GestureDetector(
      onTap: () {
        if (_userEmail.text != "") resetPassword(_userEmail.text);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerRight,
        child: Text('Forgot Password ?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _skipButton() {
    return GestureDetector(
      onTap: () {
        _login();
      },
      child: Container(
        child: Text(
          'Skip Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Commons.gradientBackgroundColorStart,
                  Commons.gradientBackgroundColorEnd
                ])),
      ),
    );
  }

  _login() {
    final storage = FlutterSecureStorage();
    storage.write(key: "loginstatus", value: "loggedin");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InitializeProviderDataScreen()));
  }

  _loginWithPhoneAndPassword(User user) {
    final storage = FlutterSecureStorage();
    storage.write(key: "loginstatus", value: "loggedin");
    storage.write(key: "email", value: user.email);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InitializeProviderDataScreen()));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5.0,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: Text(
              'Register',
              style: TextStyle(
                  color: Commons.mainAppFontColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      key: Key("userPhone"),
      keyboardType: TextInputType.number,
      controller: _userEmail,
      validator: (value) => (value.isEmpty) ? "Please Enter Email" : null,
      style: style,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone_in_talk, color: Commons.mainAppColor),
          labelText: "Phone Number",
          border: OutlineInputBorder()),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      key: Key("userPassword"),
      controller: _userPassword,
      obscureText: _obscureText,
      validator: (value) => (value.isEmpty) ? "Please Enter Password" : null,
      style: style,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: Commons.mainAppColor,
          ),
          labelText: "Password",
          border: OutlineInputBorder()),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _emailField(),
        SizedBox(
          height: 20,
        ),
        _passwordField(),
        FlatButton(
            onPressed: _togglePassword,
            child: new Text(_obscureText ? "Show" : "Hide")),
      ],
    );
  }

  Future<void> resetPassword(String email) async {
    await _authFirebase.sendPasswordResetEmail(email: email);
  }
}
