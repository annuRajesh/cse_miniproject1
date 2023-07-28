import 'dart:developer';
import 'package:cse_miniproject/screens/homeScreen.dart';
import 'package:cse_miniproject/screens/readReview.dart';

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

class FoodList extends StatefulWidget {
  static const routeName = "/foodList";
  final String sellerId;

  FoodList({this.sellerId});

  @override
  _FoodListState createState() => _FoodListState();
}

TextEditingController review = TextEditingController();
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
          slid: doc.get('seller_id'));
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

  Food({this.name, this.description, this.price, this.foodId, this.slid});
}

class _FoodListState extends State<FoodList> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Food> foods = [];
  List<Food> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  Future<void> fetchFoods() async {
    List<Food> items = await service.getFoodList(widget.sellerId);
    setState(() {
      foods = items;
    });
  }

  void addToCart(Food food, int quantity) async {
    setState(() {
      cartItems.add(food);
    });
    double totalPrice = double.parse(food.price) * quantity;
    await db.collection('cart').add({
      'foodId': food
          .foodId, // Assuming foodId is a unique identifier for the food item
      'name': food.name,
      'description': food.description,
      'price': totalPrice.toString(),
      'quantity': quantity,
      'timestamp': FieldValue.serverTimestamp(),
      'user_id': userId,
      'seller_id': food.slid
    });

    showSuccessDialog();
  }

  void showAddToCartDialog(Food food) async {
    int quantity = 1; // Default quantity is 1

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to Cart'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter the quantity:'),
              SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  quantity = int.tryParse(value) ?? 1;
                },
                decoration: InputDecoration(
                  hintText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                addToCart(food, quantity);
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Item successfully added to the cart.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> WriteReview(Food food) {
      return showDialog(
          context: context,
          builder: (BuildContext) {
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
                        child: Text('OK')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel')),
                  ],
                )
              ],
            );
          });
    }

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
                                        'write Review',
                                        style:
                                            TextStyle(color: Colors.red[300]),
                                      ),
                                      onTap: (() {
                                        WriteReview(food);
                                      })),
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
                                              arguments: food.foodId);
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        // Add Button
                        ElevatedButton(
                          onPressed: () {
                            showAddToCartDialog(food);
                          },
                          child: Text('Add'),
                        ),
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
