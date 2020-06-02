
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personel_takip/signup.dart';
class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState() {
    
    return new LoginPageState();
  }

}


class LoginPageState extends State<LoginPage> {
  static final String path = "lib/login.dart";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  String _email;
  String _pass;

  String _emailErrorText;
  String _passErrorText;
  String _loginMessage = " ";

  bool _validateEmail = false;
  bool _validetEmail_isEmail = false;
  bool _validatePass = false;




  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 100.0),
              Stack(
                children: <Widget>[
                  Positioned(
                    left: 20.0,
                    top: 20.0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(20.0)),
                      width: 150.0,
                      height: 10.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text(
                      "Giriş Yap",
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
                  _loginMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: TextField(
                  onChanged: (textEmail) {
                    _email = textEmail;
                    _emailErrorText = null ;
                    
                  },
                  controller: _emailTextController,
                  decoration: InputDecoration(
                      labelText: "Email", hasFloatingPlaceholder: true,
                      errorText: _emailErrorText,
                      ),
            
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: TextField(
                  onChanged:(textPass) {
                    _pass = textPass;
                    _passErrorText = null ;
                  },
                  obscureText: true,
                  controller: _passwordTextController,
                  decoration: InputDecoration(
                      labelText: "Şifre", hasFloatingPlaceholder: true,
                      errorText: _passErrorText),
                        // ||
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(right: 16.0),
                  alignment: Alignment.centerRight,
                  child: Text("Şifreni mi unuttun?")),
              const SizedBox(height: 120.0),
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
                      _emailTextController.text.isEmpty ? _validateEmail = true: _validateEmail=false;
                      _passwordTextController.text.isEmpty ? _validatePass = true: _validatePass = false;
                      _validetEmail_isEmail = isEmail(_email);

                      if(_validateEmail ){
                          _emailErrorText =  "Bu alan bos birakilamaz!" ;
                      }else if(_validetEmail_isEmail == false){
                           _emailErrorText =  "Mail adresinizi doğru girdiğinizden emin olunuz!!" ;
                      }

                      if(_validatePass ){
                          _passErrorText =  "Bu alan bos birakilamaz!" ;
                      }


                      if(_emailErrorText == null && _passErrorText ==null ){
                        _loginToAccount(_email, _pass);

                      }
                      
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Gİrİş Yap".toUpperCase(),
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
              Align(
                alignment: Alignment.centerLeft,
                child: RaisedButton(
                  padding: const EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.arrowLeft,
                        size: 18.0,
                      ),
                      const SizedBox(width: 40.0),
                      Text(
                        "Kayıt Ol".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
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

 
  RegExp regExp = new RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
  if(em != null){
    print(regExp.hasMatch(em));
    return regExp.hasMatch(em);
  }
   
}
 void _loginToAccount(String email , String pass){
   _auth.signInWithEmailAndPassword(email: email, password: pass).then((loginUser){
     setState(() {
       

        if(loginUser.user.isEmailVerified){
                _loginMessage = "Basariyla giris yapildi :p";
            }else{
              _loginMessage = "Lutfen mailinizden hesabinizi aktif ediniz!";
            }



     });
     

   }).catchError((e){
     setState(() {
       _loginMessage = "Email veya sifre hatali";
     });
   });
 }

}
