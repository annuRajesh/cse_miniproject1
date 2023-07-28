import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_miniproject/screens/dessertScreen.dart';
import 'package:cse_miniproject/widgets/customNavBar.dart';
import '../screens/dessertScreen.dart';

FirebaseAuth firebase = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class MenuScreen extends StatelessWidget {
  static const routeName = "/menuScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Catagories', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                child: Center(
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                          child: Column(
                        children: [
                          Center(
                            child: SizedBox(
                              height: 50,
                              child: Text(
                                'Desserts',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[300]),
                              ),
                            ),
                          )
                        ],
                      )),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => CatagoryScreen(category: 'desserts'),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                child: Center(
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                          child: Column(
                        children: [
                          Center(
                            child: SizedBox(
                              height: 50,
                              child: Text(
                                'Beverages',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[300]),
                              ),
                            ),
                          )
                        ],
                      )),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => CatagoryScreen(category: 'beverages'),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                child: Center(
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                          child: Column(
                        children: [
                          Center(
                            child: SizedBox(
                              height: 50,
                              child: Text(
                                'Foods',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[300]),
                              ),
                            ),
                          )
                        ],
                      )),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => CatagoryScreen(category: 'foods'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomNavBar(profile: true),
        ],
      ),
    );
  }
}
