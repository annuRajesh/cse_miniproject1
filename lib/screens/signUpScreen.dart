import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/homeScreen.dart';
import '../const/colors.dart';
import '../screens/loginScreen.dart';
import '../utils/helper.dart';
import '../widgets/customTextInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signUpScreen';
  final TextEditingController signup_name = TextEditingController();
  final TextEditingController signup_email = TextEditingController();
  final TextEditingController signup_mobile = TextEditingController();
  final TextEditingController signup_address = TextEditingController();
  final TextEditingController signup_password = TextEditingController();
  final TextEditingController signup_newPassword = TextEditingController();
  bool isEmailvalid = true;
  void ValidateEmail(String val) {
    isEmailvalid = EmailValidator.validate(val);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create an Account"),
          leading: BackButton(onPressed: () {
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          }),
        ),
        body: Container(
          width: Helper.getScreenWidth(context),
          height: Helper.getScreenHeight(context),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                children: [
                  Text(
                    "Sign Up",
                    style: Helper.getTheme(context).headline6,
                  ),
                  Spacer(),
                  Text(
                    "Add your details to sign up",
                  ),
                  Spacer(),
                  Text("Name"),
                  TextField(
                    controller: signup_name,
                  ),
                  Spacer(),
                  Text('Email'),
                  TextField(
                    controller: signup_email,
                    onChanged: (val) {
                      ValidateEmail(val);
                      if (isEmailvalid != null) {
                        return AlertDialog(
                          title: const Text("invalid Email"),
                          actions: [
                            TextButton(
                                onPressed: Navigator.of(context).pop,
                                child: Text("OK"))
                          ],
                        );
                      }
                    },
                  ),
                  Spacer(),
                  Text("Mobile no"),
                  TextField(
                    controller: signup_mobile,
                  ),
                  Spacer(),
                  Text("Address"),
                  TextField(
                    controller: signup_address,
                  ),
                  Spacer(),
                  Text("Password"),
                  TextField(
                    controller: signup_password,
                  ),
                  Spacer(),
                  Text("Confirm Password"),
                  TextField(
                    controller: signup_newPassword,
                  ),
                  Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          if (signup_password.text != signup_newPassword.text) {
                            showDialog(
                                context: context,
                                builder: (BuildContext) {
                                  return AlertDialog(
                                    title: const Text("password dosen't match"),
                                    actions: [
                                      TextButton(
                                          onPressed: Navigator.of(context).pop,
                                          child: Text("OK"))
                                    ],
                                  );
                                });
                          } else {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                                    email: signup_email.text,
                                    password: signup_password.text);
                            String userId = userCredential.user.uid;
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            await firestore
                                .collection('users')
                                .doc(userId)
                                .set({
                              'Name': signup_name.text,
                              'Email': signup_email.text,
                              'Mobile': signup_mobile.text,
                              'Address': signup_address.text,
                              "Password": signup_password.text,
                              "newPassword": signup_newPassword.text,
                            });
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.routeName);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text("Sign Up"),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an Account?"),
                        Text(
                          "Login",
                          style: TextStyle(
                            color: AppColor.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
