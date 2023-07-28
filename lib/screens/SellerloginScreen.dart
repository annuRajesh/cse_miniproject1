import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/Seller_intro.dart';
import 'package:cse_miniproject/screens/forgetPwScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cse_miniproject/screens/landingScreen.dart';
import 'package:cse_miniproject/screens/sellar_signUpScreen.dart';
import '../const/colors.dart';
import '../screens/forgetPwScreen.dart';
import '../screens/homeScreen.dart';
import '../screens/signUpScreen.dart';
import '../utils/helper.dart';
import '../widgets/customTextInput.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/SellarSubmission.dart';

class SellerLoginScreen extends StatelessWidget {
  static const routeName = "/SellerloginScreen";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homely"),
        leading: BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
      ),
      body: Container(
        height: Helper.getScreenHeight(context),
        width: Helper.getScreenWidth(context),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 30,
            ),
            child: Column(
              children: [
                Text(
                  "Login",
                  style: Helper.getTheme(context).headline6,
                ),
                Spacer(),
                Text('Add your details to login'),
                Spacer(),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                Spacer(),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                Spacer(),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String email =
                          ''; // Declare and initialize the email variable
                      String password = '';
                      email = emailController.text;
                      password = passwordController.text;
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                          // Get the values from the corresponding TextFormField widgets
                        );
                        User user = userCredential.user;
                        Navigator.of(context).pushReplacementNamed(
                            sellerIntro.routeName,
                            arguments: user);
                        print('Successfully logged in: $user');

                        // You can redirect the user to another page or perform any other desired action here
                      } catch (e) {
                        print('Login error: $e');
                        showDialog(
                            context: context,
                            builder: (BuildContext) {
                              return AlertDialog(
                                title: const Text("ERROR"),
                                content: Text('User not found'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('ok'))
                                ],
                              );
                            });
                        // Handle login errors here (e.g., display an error message)
                      }
                    },
                    child: Text("Chef Login"),
                  ),
                ),
                Spacer(),
                Spacer(
                  flex: 2,
                ),
                Spacer(
                  flex: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SellerSignUpScreen.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an Account?"),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(SellerSubmit.routeName);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('if you are new '),
                          Text(
                            'click here',
                            style: TextStyle(color: Colors.lightGreen),
                          )
                        ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
