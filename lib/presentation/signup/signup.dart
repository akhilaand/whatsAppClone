import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/presentation/homeScreen/homeScreen.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  AuthMethods _authMethods = AuthMethods();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  TextEditingController _passController = TextEditingController();
  var isSpinning = false;
  isMe() {
    if (_formKey.currentState.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isSpinning,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
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
                            ? "please provide user details"
                            : null;
                      },
                      controller: _userNameController,
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
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                  child: Text("Sign up"),
                  color: Colors.blue,
                  height: 50,
                  minWidth: 200,
                  onPressed: () {
                    isMe();
                    Map<String, String> userInfoMap = {
                      "name": _userNameController.text,
                      "email": _emailController.text
                    };
                    setState(() {
                      isSpinning = true;
                    });
                    _authMethods
                        .signUpWithEmailandPassword(
                            _emailController.text, _passController.text)
                        .catchError((onError) {
                      print("error on signUp $onError");
                    });
                    HelperFunctions.saveUserLoggedInSharedPreference(true);
                    HelperFunctions.saveUserNameSharedPreference(
                        _userNameController.text);
                    HelperFunctions.saveUserEmailSharedPreference(
                        _emailController.text);

                    _dataBaseMethods.uploadUserInfo(userInfoMap);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                    setState(() {
                      isSpinning = false;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
