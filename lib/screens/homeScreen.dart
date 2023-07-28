import 'dart:developer';
import '../widgets/customNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/checkoutScreen.dart';
import 'package:cse_miniproject/screens/inboxScreen.dart';
import 'package:cse_miniproject/screens/myOrderScreen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import '../const/colors.dart';
import '../utils/helper.dart';
import '../widgets/customNavBar.dart';
import '../screens/individualItem.dart';
import '../widgets/searchBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/foodList.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

FirebaseService service = FirebaseService();

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Company>> companyList() async {
    QuerySnapshot querySnapshot = await firestore.collection('seller').get();
    List<Company> companies = querySnapshot.docs.map((doc) {
      return Company(
          companyName: doc.get('company name') as String,
          Owname: doc.get('name') as String,
          fssai: doc.get('fssai') as String,
          sellerId: doc.id);
    }).toList();
    return companies;
  }
}

class Company {
  final String companyName;
  final String Owname;
  final String fssai;
  final String sellerId;

  Company({this.companyName, this.Owname, this.fssai, this.sellerId});
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<void> navigateToFoodList(String sellerId) async {
    Navigator.of(context).pushNamed(
      FoodList.routeName,
      arguments: sellerId,
    );
  }

  List<Company> companys = [];
  //User user;
  String login_name = '';
  @override
  void initState() {
    super.initState();
    fetchName();
    fetchCompany();
  }

  Future<void> fetchCompany() async {
    List<Company> items = await service.companyList();
    setState(() {
      companys = items;
    });
  }

  Future<String> fetchName() async {
    // User user;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot ds = await db.collection("users").doc(user.uid).get();
      setState(() {
        login_name = ds.get('Name');
      });
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    List<Company> nonEmptyCompanies =
        companys.where((company) => company.companyName.isNotEmpty).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome $login_name",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Home Bakeries',
                style: TextStyle(fontSize: 40, color: Colors.green[800]),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: nonEmptyCompanies.length,
                itemBuilder: (context, index) {
                  final company = nonEmptyCompanies[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        String sellerId = company
                            .sellerId; // Access the document ID of the seller
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FoodList(
                                sellerId:
                                    sellerId), // Pass the sellerId to the FoodList screen
                          ),
                        );
                        if (company.companyName.isEmpty) {
                          // Exclude documents with empty company name
                          return SizedBox.shrink();
                        }
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company.companyName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Owner: ${company.Owname}",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.red[800]),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "FSSAI: ${company.fssai}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
