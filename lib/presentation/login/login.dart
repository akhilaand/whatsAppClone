import 'package:chat_app/helper/helperFunction.dart';

import 'package:chat_app/presentation/homeScreen/homeScreen.dart';

import 'package:chat_app/presentation/signup/signup.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  AuthMethods _authMethods = AuthMethods();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _nameController = TextEditingController();

  TextEditingController _passController = TextEditingController();
  bool isSpinning = false;
  isMe() {
    if (_formKey.currentState.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isSpinning,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty || val.length <= 3
                            ? "please provide valid user name"
                            : null;
                      },
                      controller: _nameController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty || val.length <= 3
                            ? "please provide user details"
                            : null;
                      },
                      controller: _emailController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty || val.length <= 6
                            ? "please provide password details"
                            : null;
                      },
                      controller: _passController,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                  child: Text("Login"),
                  color: Colors.blue,
                  height: 50,
                  minWidth: 200,
                  onPressed: () {
                    isMe();
                    setState(() {
                      isSpinning = true;
                    });
                    _authMethods.signInWithEmail("akhil@gmail.com", "123456");
                    print("username is${_nameController.text}");
                    HelperFunctions.saveUserLoggedInSharedPreference(true);
                    HelperFunctions.saveUserNameSharedPreference(
                        _nameController.text);
                    HelperFunctions.saveUserEmailSharedPreference(
                        _emailController.text);

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                    setState(() {
                      isSpinning = false;
                    });
                  }),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                  child: Text("Sign up"),
                  color: Colors.blue,
                  height: 50,
                  minWidth: 200,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignUp()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
