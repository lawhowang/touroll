import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:touroll/components/login_only.dart';
import 'package:touroll/services/auth.dart';
import 'package:touroll/services/user.dart';

class UpdatePasswordScreen extends StatefulWidget {
  UpdatePasswordScreen({Key key}) : super(key: key);

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  UserService userService = UserService();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  bool updatingPassword = false;

  @override
  void dispose() {
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoginOnly(
      builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text('Update Password'),
          ),
          body: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return 'Password is required';
                      }
                    },
                  ),
                  TextFormField(
                    controller: repeatPasswordController,
                    decoration: InputDecoration(labelText: 'Repeat password'),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (String value) {
                      if (value != passwordController.text) {
                        return 'Password is different';
                      }
                      if (value.trim().isEmpty) {
                        return 'Please repeat the password here';
                      }
                    },
                  ),
                  TextButton(
                      onPressed: updatingPassword
                          ? null
                          : () async {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              setState(() {
                                updatingPassword = true;
                              });
                              try {
                                String password = passwordController.text;
                                await userService.updatePassword(password);
                                Navigator.pop(context);
                              } catch (ex) {}
                              setState(() {
                                updatingPassword = false;
                              });
                            },
                      child: Text('Confirm'))
                ],
              ),
            ),
          )),
    );
  }
}
