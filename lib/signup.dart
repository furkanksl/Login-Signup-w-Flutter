import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupPage extends StatefulWidget {
  @override
  SignupPageState createState() {
    return new SignupPageState();
  }
}

class SignupPageState extends State<SignupPage> {
  static final String path = "lib/signup.dart";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _passwordAgainTextController = TextEditingController();
  String _email;
  String _pass;
  String _passAgain;

  String _emailErrorText;
  String _passErrorText;
  String _passAgainErrorText;
  String _createUserErrorMessage = "";

  bool _validateEmail = false;
  bool _validetEmail_isEmail = false;
  bool _validatePass = false;
  bool _validatePassAgain = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80.0),
              Stack(
                children: <Widget>[
                  Positioned(
                    left: 20.0,
                    top: 15.0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(20.0)),
                      width: 70.0,
                      height: 20.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: Text(
                  _createUserErrorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: TextField(
                  controller: _emailTextController,
                  onChanged: (textEmail) {
                    _email = textEmail;
                    _emailErrorText = null;
                  },
                  decoration: InputDecoration(
                      labelText: "Email",
                      hasFloatingPlaceholder: true,
                      errorText: _emailErrorText),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: TextField(
                  controller: _passwordTextController,
                  onChanged: (textPass) {
                    _pass = textPass;
                    _passErrorText = null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Şifre",
                      hasFloatingPlaceholder: true,
                      errorText: _passErrorText),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: TextField(
                  controller: _passwordAgainTextController,
                  onChanged: (textPassAgain) {
                    _passAgain = textPassAgain;
                    _passAgainErrorText = null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Tekrar Şifre",
                      hasFloatingPlaceholder: true,
                      errorText: _passAgainErrorText),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(text: ""),
                    TextSpan(
                        text: "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.indigo)),
                    TextSpan(text: ""),
                  ]),
                ),
              ),
              const SizedBox(height: 60.0),
              Align(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  padding: const EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
                  color: Colors.yellow,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0))),
                  onPressed: () {
                    setState(() {
                      _emailTextController.text.isEmpty
                          ? _validateEmail = true
                          : _validateEmail = false;
                      _passwordTextController.text.isEmpty
                          ? _validatePass = true
                          : _validatePass = false;
                      _passwordAgainTextController.text.isEmpty
                          ? _validatePassAgain = true
                          : _validatePassAgain = false;
                      _validetEmail_isEmail = isEmail(_email);

                      if (_validateEmail) {
                        _emailErrorText = "Bu alan bos birakilamaz!";
                      } else if (_validetEmail_isEmail == false) {
                        _emailErrorText =
                            "Mail adresinizi doğru girdiğinizden emin olunuz!!";
                      }
                      if (_validatePass) {
                        _passErrorText = "Bu alan bos birakilamaz!";
                      } else if (_pass.length < 5) {
                        _passErrorText =
                            "Şifreniz en az 6 karakterden oluşmalıdır !";
                      } else if (_pass != _passAgain) {
                        _passAgainErrorText = "Şifreler eşleşmiyor!";
                      }

                      if (_validatePassAgain) {
                        _passAgainErrorText = "Bu alan bos birakilamaz!";
                      } else if (_pass != _passAgain) {
                        _passAgainErrorText = "Şifreler eşleşmiyor!";
                      }

                      if (_emailErrorText == null &&
                          _passErrorText == null &&
                          _passAgainErrorText == null) {
                        _email_and_pass_create_user(_email, _pass);
                        _createUserErrorMessage = "";
                      }
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Kayıt ol".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      const SizedBox(width: 40.0),
                      Icon(
                        FontAwesomeIcons.arrowRight,
                        size: 18.0,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isEmail(String em) {
    RegExp regExp =
        new RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
    if (em != null) {
      print(regExp.hasMatch(em));
      return regExp.hasMatch(em);
    }
  }

  void _email_and_pass_create_user(String email, String pass) async {
    var firebaseUser = (await _auth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .catchError((e) {
          if (e is PlatformException) {
          setState(() {
            _createUserErrorMessage = "Bu mail başka hesap tarafından kullanılıyor";
          });
        } else {
      setState(() {
        _createUserErrorMessage = "Kayit Yapilamadi.";
        print("***HATA**");
        print(e.toString());
      });
        }
    }));

    if (firebaseUser != null) {
      firebaseUser.user.sendEmailVerification().then((data) {_auth.signOut();}).catchError((e) {
        
          print(" = " + e.toString());
          setState(() {
            _createUserErrorMessage =
                "Email verifikasyon hatasi ";
          });

      });


    }
  }
}
