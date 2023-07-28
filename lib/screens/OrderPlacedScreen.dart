import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/orderPlacedScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_miniproject/const/colors.dart';

class OrderPlacedScreen extends StatelessWidget {
  static const routeName = "/OrderPlacedScreen"; // Add this line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Placed'),
      ),
      body: Center(
        child: Text(
          'Your order has been successfully placed.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
