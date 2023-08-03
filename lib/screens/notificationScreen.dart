import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = "/NotificationScreen";

  final User user = FirebaseAuth.instance.currentUser;
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference notificationCollection =
      FirebaseFirestore.instance.collection('notification');
// Function to create a new notification document
  // Function to create a new notification document

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // User is not authenticated, handle accordingly
      return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            orderCollection.where('buyer id', isEqualTo: user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No data found.'),
            );
          } else {
            List<DocumentSnapshot<Map<String, dynamic>>> documents =
                snapshot.data.docs;
            List<Map<String, dynamic>> notificationList =
                documents.map((doc) => doc.data()).toList();

            if (notificationList.isEmpty) {
              return const Center(
                child: Text('No notifications found.'),
              );
            }

            return ListView.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> notificationData = notificationList[index];
                print('Notification Data: $notificationData');

                var orderStatus = notificationData['order_status'];
                print('Order Status: $orderStatus');

                var notificationTime = notificationData['time'];
                print('Notification Time: $notificationTime');

                String statusMessage = getOrderStatusMessage(orderStatus);
                if (orderStatus == null) {
                  return ListTile(
                    title: const Text('Notification'),
                    subtitle: const Text('No status available'),
                    trailing: Text(notificationTime ?? ""),
                  );
                  ;
                }

                switch (orderStatus) {
                  case 'accept':
                    return ListTile(
                      title: const Text('Notification'),
                      subtitle: const Text('Your order has been accepted'),
                      trailing: Text(notificationTime ?? ""),
                    );
                  case 'packed':
                    return ListTile(
                      title: const Text('Notification'),
                      subtitle: const Text('Your order has been packed'),
                      trailing: Text(notificationTime ?? ""),
                    );

                  case 'shipped':
                    return ListTile(
                      title: const Text('Notification'),
                      subtitle: const Text('Your order has been shipped'),
                      trailing: Text(notificationTime ?? ""),
                    );
                  default:
                    return ListTile(
                      title: const Text('Notification'),
                      subtitle: Text('$orderStatus'),
                      trailing: Text(notificationTime ?? ""),
                    );
                }
              },
            );
          }
        },
      ),
    );
  }

  String getOrderStatusMessage(String orderStatus) {
    print("Order status received: $orderStatus");
  }
}
