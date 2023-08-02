import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_miniproject/screens/sellerOrders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User user = FirebaseAuth.instance.currentUser;
CollectionReference ordercollection =
    FirebaseFirestore.instance.collection('orders');
Future<void> Ordercollection() async {
  QuerySnapshot snapshot =
      await ordercollection.where('seller_id', isEqualTo: user.uid).get();
  List<OrderCard> ordercards = snapshot.docs.map((doc) {
    return OrderCard(doc['date'], doc['payment_mode']);
  }).toList();
  return ordercards;
}

class SellerNotificationScreen extends StatelessWidget {
  const SellerNotificationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Notifications')),
        body: FutureBuilder<List<OrderCard>>(
          future: Ordercollection(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError)
              ;
            else {
              List<OrderCard> ordercards = snapshot.data;
              return ListView.builder(itemBuilder: (context, index) {
                return ordercards[index];
              });
            }
          }),
        ));
  }
}

class OrderCard extends StatelessWidget {
  final String date, mode;
  OrderCard(this.date, this.mode);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
            child: Column(
          children: [
            Text('Order recived'),
            Text('date recieved:$date'),
            Text('mode of payment: $mode')
          ],
        )),
      ),
    );
  }
}
