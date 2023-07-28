import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/homeScreen.dart';
import 'package:cse_miniproject/screens/seller_foodlist.dart';
import '../const/colors.dart';
import '../screens/loginScreen.dart';
import '../utils/helper.dart';
import '../widgets/customTextInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

class EnterFoodList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}

class EnterFood extends StatelessWidget {
  static const routeName = '/EnterFood';
  final TextEditingController product_name = TextEditingController();
  final TextEditingController product_catagory = TextEditingController();
  final TextEditingController Product_description = TextEditingController();
  final TextEditingController product_price = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Enter the food item"),
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
                    "Your Product",
                    style: Helper.getTheme(context).headline6,
                  ),
                  Spacer(),
                  Text(
                    "Add your details",
                  ),
                  Spacer(),
                  Text("Name"),
                  TextField(
                    controller: product_name,
                  ),
                  Spacer(),
                  Text("Description"),
                  TextField(
                    controller: Product_description,
                  ),
                  Spacer(),
                  Text("catagory"),
                  TextField(
                    controller: product_catagory,
                  ),
                  Spacer(),
                  Text('price'),
                  TextField(
                    controller: product_price,
                  ),
                  Spacer(),
                  Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;
                          String userId = FirebaseAuth.instance.currentUser.uid;
                          await firestore.collection('product').add({
                            'name': product_name.text,
                            'catagory': product_catagory.text,
                            'description': Product_description.text,
                            'price': product_price.text,
                            'seller_id': userId
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext) {
                                return AlertDialog(
                                  title: const Text('Successfully added'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  SellerFoodList.routeName);
                                        },
                                        child: Text('ok'))
                                  ],
                                );
                              });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text("Enter Food"),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ));
  }
}
