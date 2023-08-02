import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_miniproject/screens/menuScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cse_miniproject/const/colors.dart';
import 'package:cse_miniproject/utils/helper.dart';
import 'package:cse_miniproject/widgets/customNavBar.dart';

User user = FirebaseAuth.instance.currentUser;
CollectionReference<Map<String, dynamic>> notification = FirebaseFirestore
    .instance
    .collection('notification')
    .where('buyer_id', isEqualTo: user.uid);
CollectionReference<Map<String, dynamic>> product =
    FirebaseFirestore.instance.collection('product');
Future<List<Map<String, dynamic>>> getNotification() async {
  List<Map<String, dynamic>> notilist = [];
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await notification.get();
    querySnapshot.docs.forEach((document) {
      notilist.add(document.data());
    });
    return notilist;
  } catch (e) {
    print(
      "trouble in getting list:$e",
    );
  }
}

class NotificationScreen extends StatelessWidget {
  static const routeName = "/notiScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getNotification(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            List<Map<String, dynamic>> notilist = snapshot.data;
            return ListView.builder(
              itemCount: notilist.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> notificationData = notilist[index];
                var status = notificationData['status'] as List<dynamic>;
                return ListTile();
              },
            );
          }
        }),
      ),
    );
  }
}
