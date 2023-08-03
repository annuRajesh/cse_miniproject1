import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_miniproject/screens/menuScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cse_miniproject/const/colors.dart';
import 'package:cse_miniproject/utils/helper.dart';
import 'package:cse_miniproject/widgets/customNavBar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = "/notiScreen";

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Initialize Firebase Messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the incoming message and show a local notification
      showNotification(message.data['title'], message.data['body']);
    });

    // Initialize the local notifications plugin
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id', // Change this to a unique ID for your app
      'Channel Name', // Change this to a custom name for the channel
      // Change this to a custom description for the channel
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Change this to a unique ID for each notification
      title,
      body,
      platformChannelSpecifics,
      payload:
          'payload', // Optionally pass data associated with the notification
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = _auth.currentUser;
    final CollectionReference<Map<String, dynamic>> ordersCollection =
        _firestore.collection('orders');

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ordersCollection
            .where('buyer_id', isEqualTo: user.uid)
            .snapshots(), // Listen for changes in the collection
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> notilist = [];
            snapshot.data?.docs.forEach((document) {
              notilist.add(document.data());
            });

            if (notilist.isEmpty) {
              return Center(
                child: Text('No notifications found.'),
              );
            }

            return ListView.builder(
              itemCount: notilist.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> orderData = notilist[index];
                var orderStatus = orderData['order_status'];
                return ListTile(
                  title: Text('Notification'),
                  subtitle: Text('Order Status: $orderStatus'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
