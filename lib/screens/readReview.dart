import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/foodList.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth firebase = FirebaseAuth.instance;
final String useId = firebase.currentUser.uid;
String review = '';
Future<List<String>> fetchReview(String userId1) async {
  QuerySnapshot snapshot = await db.collection('review').get();

  List<String> reviews = [];
  snapshot.docs.forEach((doc) {
    String reviewText = doc.get('review') as String;
    reviews.add(reviewText);
  });
  return reviews;
}

class ReadReview extends StatelessWidget {
  final String productId;

  const ReadReview({Key key, this.productId}) : super(key: key);
  static const routeName = './ReadReview';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Reviews'),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(FoodList.routeName);
          },
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchReview(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> reviews = snapshot.data;

            if (reviews.isEmpty) {
              return Center(
                child: Text('No reviews available.'),
              );
            }

            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(reviews[index]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error retrieving reviews.'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
