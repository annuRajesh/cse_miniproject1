import 'package:cse_miniproject/screens/Seller_intro.dart';
import 'package:cse_miniproject/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/SellarSubmission.dart';
import 'package:cse_miniproject/screens/SellerloginScreen.dart';
//import 'package:clip_shadow/clip_shadow.dart';
import 'package:cse_miniproject/screens/loginScreen.dart';
import 'package:cse_miniproject/screens/signUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import '../const/colors.dart';
import '../utils/helper.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = "/landingScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome"),
        ),
        body: Container(
          width: Helper.getScreenWidth(context),
          height: Helper.getScreenHeight(context),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                    Helper.getAssetName("iconhomely.png", "virtual")),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  height: Helper.getScreenHeight(context) * 0.3,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            User user = auth.currentUser;

                            if (user != null) {
                              Navigator.of(context)
                                  .pushReplacementNamed(HomeScreen.routeName);
                            } else {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginScreen.routeName);
                            }
                          },
                          child: Text("Login"),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            User user = auth.currentUser;

                            if (user != null) {
                              Navigator.of(context)
                                  .pushReplacementNamed(sellerIntro.routeName);
                            } else {
                              Navigator.of(context).pushReplacementNamed(
                                  SellerLoginScreen.routeName);
                            }
                          },
                          child: Text("Homely Chef"),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.lightGreen),
                            shape: MaterialStateProperty.all(
                              StadiumBorder(
                                side: BorderSide(
                                    color: Colors.lightGreen, width: 1.5),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(SignUpScreen.routeName);
                          },
                          child: Text("Create an Account"),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class CustomClipperAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Offset controlPoint = Offset(size.width * 0.24, size.height);
    Offset endPoint = Offset(size.width * 0.25, size.height * 0.96);
    Offset controlPoint2 = Offset(size.width * 0.3, size.height * 0.78);
    Offset endPoint2 = Offset(size.width * 0.5, size.height * 0.78);
    Offset controlPoint3 = Offset(size.width * 0.7, size.height * 0.78);
    Offset endPoint3 = Offset(size.width * 0.75, size.height * 0.96);
    Offset controlPoint4 = Offset(size.width * 0.76, size.height);
    Offset endPoint4 = Offset(size.width * 0.79, size.height);
    Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width * 0.21, size.height)
      ..quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      )
      ..quadraticBezierTo(
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint2.dx,
        endPoint2.dy,
      )
      ..quadraticBezierTo(
        controlPoint3.dx,
        controlPoint3.dy,
        endPoint3.dx,
        endPoint3.dy,
      )
      ..quadraticBezierTo(
        controlPoint4.dx,
        controlPoint4.dy,
        endPoint4.dx,
        endPoint4.dy,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
