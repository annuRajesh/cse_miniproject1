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

class OrderList extends StatefulWidget {
  static const routeName = "/orderList";
  final String sellerId;

  OrderList({this.sellerId});

  @override
  _OrderListState createState() => _OrderListState();
}

TextEditingController review = TextEditingController();
String userId = FirebaseAuth.instance.currentUser.uid;
FirebaseService service = FirebaseService();

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Order>> getOrderList(String sellerId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('orders')
        .where('seller_id', isEqualTo: sellerId)
        .get();
    List<Order> orders = querySnapshot.docs.map((doc) {
      return Order(
        orderId: doc.id,
        buyerId: doc.get('buyer_id') as String,
        date: doc.get('date') as String,
        orderStatus: doc.get('order_status') as String,
        sellerId: doc.get('seller_id') as String,
        time: doc.get('time') as String,
        type: doc.get('type') as String,
      );
    }).toList();
    return orders;
  }
}

class Order {
  final String orderId;
  final String buyerId;
  final String date;
  final String orderStatus;
  final String sellerId;
  final String time;
  final String type;

  Order({
    this.orderId,
    this.buyerId,
    this.date,
    this.orderStatus,
    this.sellerId,
    this.time,
    this.type,
  });
}

class _OrderListState extends State<OrderList> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    List<Order> items = await service.getOrderList(widget.sellerId);
    setState(() {
      orders = items;
    });
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
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
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
                        // Order Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order ID
                              Text(
                                'Order ID: ${order.orderId}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Buyer ID
                              Text(
                                'Buyer ID: ${order.buyerId}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              // Order Date
                              Text(
                                'Date: ${order.date}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              // Order Status

                              SizedBox(height: 8),
                              // Order Seller ID

                              SizedBox(height: 8),
                              // Order Time
                              Text(
                                'Time: ${order.time}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              // Order Type
                              Text(
                                'Type: ${order.type}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }
}
