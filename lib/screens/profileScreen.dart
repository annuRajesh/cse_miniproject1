import 'package:flutter/material.dart';
import 'package:cse_miniproject/const/colors.dart';
import 'package:cse_miniproject/screens/homeScreen.dart';
import 'package:cse_miniproject/screens/introScreen.dart';
import 'package:cse_miniproject/screens/loginScreen.dart';
import 'package:cse_miniproject/utils/helper.dart';
import 'package:cse_miniproject/widgets/customNavBar.dart';
//import 'package:cse_miniproject/widgets/customTextInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

//FirebaseAuth firebase = FirebaseAuth.instance;
final user = FirebaseAuth.instance.currentUser;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profileScreen";
  @override
  profileScreenstate createState() => profileScreenstate();
}

List<DocumentSnapshot> documents = [];

// ignore: camel_case_types
class profileScreenstate extends State<ProfileScreen> {
  @override
  String login_name = '';
  String login_phone = '';
  String login_add = '';
  String login_email = '';
  void initState() {
    super.initState();
    fetchData();
  }

  Future<List<DocumentSnapshot>> fetchDocuments() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    return querySnapshot.docs;
  }

  Future<void> fetchData() async {
    List<DocumentSnapshot> fetchedDocuments = await fetchDocuments();
    setState(() {
      documents = fetchedDocuments;
    });
  }

  Widget build(BuildContext context) {
    DocumentSnapshot userDocument;
    for (DocumentSnapshot document in documents) {
      if (document.id == user.uid) {
        userDocument = document;
        break;
      }
    }
    if (userDocument != null) {
      Map<String, dynamic> data = userDocument.data();
      login_name = data['Name'];
      login_email = data['Email'];
      login_add = data['Address'];
      login_phone = data['Mobile'];
    }
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              height: Helper.getScreenHeight(context),
              width: Helper.getScreenWidth(context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profile",
                            style: Helper.getTheme(context).headline5,
                          ),
                          // Image.asset(
                          //   Helper.getAssetName("cart.png", "virtual"),
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ClipOval(
                        child: Stack(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              child: Image.asset(
                                Helper.getAssetName(
                                  "user.jpg",
                                  "real",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 20,
                                width: 80,
                                color: Colors.black.withOpacity(0.3),
                                child: Image.asset(Helper.getAssetName(
                                    "camera.png", "virtual")),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Helper.getAssetName("edit_filled.png", "virtual"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Hi there $login_name !!",
                        style: Helper.getTheme(context).headline4.copyWith(
                              color: AppColor.primary,
                            ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        child:
                            Text("$login_name", style: TextStyle(fontSize: 22)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(child: Text("$login_email")),
                      SizedBox(
                        height: 20,
                      ),
                      Container(child: Text("$login_phone")),
                      SizedBox(
                        height: 20,
                      ),
                      Container(child: Text(login_add)),
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                          height: 50,
                          width: 200,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    LoginScreen.routeName);
                              },
                              child: Text('Sign Out'),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFormImput extends StatelessWidget {
  const CustomFormImput({
    Key key,
    String label,
    String value,
    bool isPassword = false,
  })  : _label = label,
        _value = value,
        _isPassword = isPassword,
        super(key: key);

  final String _label;
  final String _value;
  final bool _isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(left: 40),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.placeholderBg,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: _label,
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
        ),
        obscureText: _isPassword,
        initialValue: _value,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
