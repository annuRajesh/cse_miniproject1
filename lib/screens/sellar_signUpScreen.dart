import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/SellerloginScreen.dart';
import 'package:cse_miniproject/screens/homeScreen.dart';
import '../const/colors.dart';
import '../screens/loginScreen.dart';
import '../utils/helper.dart';
import '../widgets/customTextInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

class SellerSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}

class SellerSignUpScreen extends StatelessWidget {
  static const routeName = '/SellerSignUpScreen';
  final TextEditingController sellersignup_name = TextEditingController();
  final TextEditingController sellerfssai = TextEditingController();
  final TextEditingController sellerCompany = TextEditingController();
  final TextEditingController sellersignup_email = TextEditingController();
  final TextEditingController sellersignup_mobile = TextEditingController();
  final TextEditingController sellersignup_address = TextEditingController();
  final TextEditingController sellersignup_password = TextEditingController();
  final TextEditingController sellersignup_newPassword =
      TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

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
                    controller: sellersignup_name,
                  ),
                  Spacer(),
                  Text("FSSAI Number"),
                  TextField(
                    controller: sellerfssai,
                  ),
                  Spacer(),
                  Text("Company name"),
                  TextField(
                    controller: sellerCompany,
                  ),
                  Spacer(),
                  Text('Email'),
                  TextField(
                    controller: sellersignup_email,
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
                    controller: sellersignup_mobile,
                  ),
                  Spacer(),
                  Text("Address"),
                  TextField(
                    controller: sellersignup_address,
                  ),
                  Spacer(),
                  Text("Password"),
                  TextField(
                    controller: sellersignup_password,
                  ),
                  Spacer(),
                  Text("Confirm Password"),
                  TextField(
                    controller: sellersignup_newPassword,
                  ),
                  Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          QuerySnapshot snapshot = await db
                              .collection('seller_submit')
                              .where('Fssai', isEqualTo: sellerfssai.text)
                              .get();
                          if (sellersignup_password.text !=
                              sellersignup_newPassword.text) {
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
                          } else if (snapshot.docs.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext) {
                                  return AlertDialog(
                                    title: const Text('you cant sign up  '),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'))
                                    ],
                                  );
                                });
                          } else {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                                    email: sellersignup_email.text,
                                    password: sellersignup_password.text);
                            String userId = userCredential.user.uid;
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            await firestore
                                .collection('seller')
                                .doc(userId)
                                .set({
                              'name': sellersignup_name.text,
                              'email': sellersignup_email.text,
                              'mobile': sellersignup_mobile.text,
                              'address': sellersignup_address.text,
                              'fssai': sellerfssai.text,
                              'company name': sellerCompany.text,
                              "Password": sellersignup_password.text,
                              "newPassword": sellersignup_newPassword.text,
                            });
                            Navigator.of(context).pushReplacementNamed(
                                SellerLoginScreen.routeName);
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
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(SellerLoginScreen.routeName);
                    },
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
