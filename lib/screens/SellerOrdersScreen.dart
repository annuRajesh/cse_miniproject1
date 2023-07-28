import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cse_miniproject/screens/Seller_intro.dart';

class SellerOrdersScreen extends StatelessWidget {
  static const routeName = "/sellerOrdersScreen";
  User user = FirebaseAuth.instance.currentUser;
  TextEditingController status = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(sellerIntro.routeName);
          },
        ),
        title: Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('seller_id', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> documents = snapshot.data.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var orderData = documents[index].data() as Map<String, dynamic>;
                var items = orderData['items'] as List<dynamic>;
                var orderId = documents[index].id;

                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        subtitle:
                            Text('Order Status: ${orderData['order status']}'),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];

                          return ListTile(
                            title: Text('Item: ${item['name']}'),
                            subtitle:
                                Text('Description: ${item['description']}'),
                            trailing: Text('Price: ${item['price']}'),
                          );
                        },
                      ),
                      ListTile(
                        title:
                            Text('Payment Mode: ${orderData['payment_mode']}'),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        child: TextField(
                          controller: status,
                        ),
                      ),
                      SizedBox(
                          child: ElevatedButton(
                        onPressed: () async {
                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;
                          await firestore
                              .collection('orders')
                              .doc(orderId)
                              .set({'order status': status});
                        },
                        child: Text('submit'),
                      ))
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data.'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
