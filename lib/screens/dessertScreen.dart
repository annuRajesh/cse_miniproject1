import 'package:flutter/foundation.dart';
import 'package:cse_miniproject/screens/homeScreen.dart';
import 'package:cse_miniproject/screens/menuScreen.dart';
import 'package:cse_miniproject/screens/readReview.dart';

import '../widgets/customNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CatagoryScreen extends StatefulWidget {
  static const routeName = "/CatagoryScreen";
  final String category;
  final String sellerId;
  CatagoryScreen({this.category, this.sellerId});

  @override
  _CatagoryScreenState createState() => _CatagoryScreenState();
}

TextEditingController review = TextEditingController();
String userId = FirebaseAuth.instance.currentUser.uid;
FirebaseService service = FirebaseService();

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Food>> getFoodList(String sellerId) async {
    QuerySnapshot querySnapshot = await firestore.collection('product').get();
    List<Food> foods = querySnapshot.docs.map((doc) {
      return Food(
          foodId: doc.id,
          name: doc.get('name') as String,
          description: doc.get('description') as String,
          price: doc.get('price') as String,
          slid: doc.get('seller_id'),
          catagory1: doc.get('catagory'));
    }).toList();
    return foods;
  }
}

class Food {
  final String name;
  final String description;
  final String price;
  final String foodId;
  final String slid;
  final String catagory1;

  Food(
      {this.name,
      this.description,
      this.price,
      this.foodId,
      this.slid,
      this.catagory1});
}

class _CatagoryScreenState extends State<CatagoryScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Food> foods = [];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      fetchFoods();
    } else {
      debugPrint("Category is null");
    }
  }

  Future<void> fetchFoods() async {
    if (widget.category == null) {
      return; // Exit early if catagory is null
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('product')
        .where('catagory', isEqualTo: widget.category.toLowerCase())
        .get();

    List<Food> filteredFoods = querySnapshot.docs.map((doc) {
      return Food(
        foodId: doc.id,
        name: doc.get('name') as String,
        description: doc.get('description') as String,
        price: doc.get('price') as String,
        slid: doc.get('seller_id') as String,
        catagory1: doc.get('catagory') as String,
      );
    }).toList();

    setState(() {
      foods = filteredFoods;
    });
  }

  Future<void> WriteReview(Food food) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter review'),
          content: Container(
            width: double.maxFinite,
            child: TextField(
              controller: review,
            ),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('review')
                        .doc()
                        .set({
                      'review': review.text,
                      'userId': userId,
                      'sellerId': food.slid,
                      'productId': food.foodId
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
          color: Colors.white,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ListView.builder(
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
                                  GestureDetector(
                                    child: Text(
                                      'Write Review',
                                      style: TextStyle(color: Colors.red[300]),
                                    ),
                                    onTap: (() {
                                      WriteReview(food);
                                    }),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    child: Text(
                                      'Read Reviews',
                                      style: TextStyle(color: Colors.red[300]),
                                    ),
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        ReadReview.routeName,
                                        arguments: food.foodId,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        // Add Button
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: CustomNavBar(
                profile: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
