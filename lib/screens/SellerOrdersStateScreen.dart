import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cse_miniproject/screens/Seller_intro.dart';

class SellerStateOrdersScreen extends StatefulWidget {
  static const routeName = "/sellerStateOrdersScreen";

  @override
  _SellerStateOrdersScreenState createState() =>
      _SellerStateOrdersScreenState();
}

class _SellerStateOrdersScreenState extends State<SellerStateOrdersScreen> {
  User user = FirebaseAuth.instance.currentUser;
  TextEditingController status = TextEditingController();
  void updateStatus(String order_id, Status) async {
    // Get the reference to the specific document using the order_id.
    DocumentReference<Map<String, dynamic>> orderRef =
        FirebaseFirestore.instance.collection('orders').doc(order_id);

    // Now, you can use the 'orderRef' variable to perform various operations on the specific document.

    // For example, to get the data in the document:
    DocumentSnapshot<Map<String, dynamic>> orderSnapshot = await orderRef.get();
    if (orderSnapshot.exists) {
      Map<String, dynamic> orderData = orderSnapshot.data();
      print(orderData);
      await orderRef.update({'order_status': Status});
      // Do something with the order data...i
      CollectionReference<Map<String, dynamic>> notification =
          FirebaseFirestore.instance.collection('notification');
      //var product_id = item['foodId'];

      if (Status == 'accept') {
        //sendorderacceptnotification
        await notification.add({
          'timestamp': DateTime.now(),
          'data': {'order_id': order_id},
          'title': 'Order accepted',
          'message': 'your order has been accepted by the seller',
          'user_id': orderData['buyer id'],
          'read': false
        });
      } else if (Status == 'reject') {
        //endnotificationandrefundpayment
        await notification.add({
          'timestamp': DateTime.now(),
          'data': {'order_id': order_id},
          'title': 'Order Reject',
          'message':
              'your order has been Rejected by the seller about will be refundedn in 3 days',
          'user_id': orderData['buyer id'],
          'read': false
        });
      } else {
        print('nothing');
        // await notification.add({
        //   'timestamp': DateTime.now(),
        //   'data': {'order_id': ''},
        //   'title': '',
        //   'message': '',
        //   'user_id': '',
        //   'read': 'false'
        // });
      }
    } else {
      // Handle the case when the document does not exist.
    }
  }

  @override
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
                            Text('Order Status: ${orderData['order_status']}'),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
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
                          child: orderData['order_status'] == 'pending'
                              ? SizedBox(
                                  child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        updateStatus(orderId, 'accept');
                                      },
                                      child: Text('Accept'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        updateStatus(orderId, 'Reject');
                                      },
                                      child: Text('Reject'),
                                    ),
                                  ],
                                ))
                              : orderData['order_status'] == 'accept'
                                  ? SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          updateStatus(orderId, 'packed');
                                        },
                                        child: Text('Ready'),
                                      ),
                                    )
                                  : orderData['order_status'] == 'packed'
                                      ? SizedBox(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              updateStatus(orderId, 'shipped');
                                            },
                                            child: Text('Completed'),
                                          ),
                                        )
                                      : SizedBox()),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          updateStatus(orderId, 'pending');
                        },
                        child: Text('Reset'),
                      ),
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
