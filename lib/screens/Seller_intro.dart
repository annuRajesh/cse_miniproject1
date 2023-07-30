import 'package:cse_miniproject/screens/SellerOrdersStateScreen.dart';
import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/SellerOrdersScreen.dart';
import 'package:cse_miniproject/screens/seller_foodlist.dart';

class sellerIntro extends StatelessWidget {
  const sellerIntro({Key key}) : super(key: key);
  static const routeName = './sellerIntro';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Work Area'),
      ),
      body: Center(
          child: Container(
        padding: EdgeInsets.all(30),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                child: Text('Foods'),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(SellerFoodList.routeName);
                },
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.grey[800], elevation: 10),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                child: Text('Orders'),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(SellerStateOrdersScreen.routeName);
                },
                style: ElevatedButton.styleFrom(
                    shadowColor: Colors.grey[800], elevation: 10),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: SizedBox(
              height: 50,
              width: 200,
            ),
          ),
        ]),
      )),
    );
  }
}
