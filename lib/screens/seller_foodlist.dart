import 'dart:developer';
import 'package:cse_miniproject/screens/EnterFood.dart';
import 'package:cse_miniproject/screens/Seller_intro.dart';
import 'package:cse_miniproject/screens/homeScreen.dart';

import '../widgets/customNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/checkoutScreen.dart';
import 'package:cse_miniproject/screens/inboxScreen.dart';
import 'package:cse_miniproject/screens/myOrderScreen.dart';
import '../const/colors.dart';
import '../utils/helper.dart';
import '../widgets/customNavBar.dart';
import '../screens/individualItem.dart';
import '../widgets/searchBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerFoodList extends StatefulWidget {
  static const routeName = "/SellerFoodList";
  final String sellerId;

  SellerFoodList({this.sellerId});

  @override
  _FoodListState createState() => _FoodListState();
}

String userId = FirebaseAuth.instance.currentUser.uid;
FirebaseService service = FirebaseService();

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Food>> getFoodList(String sellerId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('product')
        .where('seller_id', isEqualTo: sellerId)
        .get();
    List<Food> foods = querySnapshot.docs.map((doc) {
      return Food(
        foodId: doc.id,
        name: doc.get('name') as String,
        description: doc.get('description') as String,
        price: doc.get('price') as String,
      );
    }).toList();
    return foods;
  }
}

class Food {
  final String name;
  final String description;
  final String price;
  final String foodId;

  Food({this.name, this.description, this.price, this.foodId});
}

class _FoodListState extends State<SellerFoodList> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Food> foods = [];
  List<Food> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  Future<void> fetchFoods() async {
    String sellerId = FirebaseAuth.instance.currentUser.uid;
    List<Food> items = await service.getFoodList(sellerId);
    setState(() {
      foods = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(sellerIntro.routeName);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Food Image
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Food Title
                                Text(
                                  food.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Food Description
                                Text(
                                  '${food.description}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                // Food Price
                                Text(
                                  'Price: rupees ${food.price}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Row(
                                  children: [
                                    Spacer(),
                                    GestureDetector(
                                      child: Text(
                                        'Read Reviews',
                                        style:
                                            TextStyle(color: Colors.red[300]),
                                      ),
                                      onTap: () {
                                        // Handle the Read Reviews onTap event
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(EnterFood.routeName);
                },
                child: Text('Add Food Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
