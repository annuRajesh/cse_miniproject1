import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_miniproject/const/colors.dart';
//import 'package:cse_miniproject/screens/checkoutScreen.dart';
import 'package:cse_miniproject/screens/paymentScreen.dart';

import 'package:cse_miniproject/screens/OrderPlacedScreen.dart';
import 'package:cse_miniproject/utils/helper.dart';
import 'package:cse_miniproject/widgets/customNavBar.dart';

class MyOrderScreen extends StatelessWidget {
  static const routeName = "/myOrderScreen";

  void _payOnDelivery(BuildContext context) {
    Navigator.pushNamed(context, OrderPlacedScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back_ios_rounded),
                        ),
                        Expanded(
                          child: Text(
                            "Cart",
                            style: Helper.getTheme(context).headline5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('cart')
                        .where('user_id', isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final cartItems = snapshot.data.docs;
                      int totalQuantity = 0;
                      int totalOrders = cartItems.length;
                      double totalPrice = 0;

                      for (var item in cartItems) {
                        final itemName = item['name'] as String;
                        final itemPrice =
                            double.tryParse(item['price'] as String);
                        final quantity = item['quantity'] as int;

                        if (itemPrice != null) {
                          totalPrice += itemPrice;
                        }

                        if (item['user_id'] == user.uid) {
                          totalQuantity += quantity;
                        }
                      }

                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              final itemName = item['name'] as String;
                              final itemPrice =
                                  double.tryParse(item['price'] as String);
                              final quantity = item['quantity'] as int;

                              return ListTile(
                                title: Text(
                                  itemName,
                                  style: TextStyle(
                                    color: AppColor.primary,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  "Price: ${itemPrice != null ? itemPrice.toString() : ''}",
                                  style: TextStyle(
                                    color: AppColor.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                trailing: Container(
                                  width: 50,
                                  child: TextFormField(
                                    initialValue: quantity.toString(),
                                    onChanged: (value) {
                                      final newQuantity =
                                          int.tryParse(value) ?? 1;
                                      // TODO: Update quantity in Firestore
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 10,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                            height: 0,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${totalPrice.toStringAsFixed(2)} INR",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (ctx) => PaymentScreen(
                                      totalPrice: totalPrice,
                                      cartItems: cartItems),
                                ),
                              );
                            },
                            child: Text("Pay Now"),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                User user = FirebaseAuth.instance.currentUser;
                                CollectionReference ordersCollection =
                                    FirebaseFirestore.instance
                                        .collection('orders');
                                Stream<QuerySnapshot> cartCollection =
                                    FirebaseFirestore.instance
                                        .collection('cart')
                                        .where('user_id', isEqualTo: user.uid)
                                        .snapshots();

                                // Retrieve the cart items from the cart collection
                                QuerySnapshot cartSnapshot =
                                    await cartCollection.first;
                                List<QueryDocumentSnapshot> cartDocuments =
                                    cartSnapshot.docs;
                                List<Map<String, dynamic>> cartItems =
                                    cartDocuments
                                        .map((doc) =>
                                            doc.data() as Map<String, dynamic>)
                                        .toList();

                                // Create an order document in the orders collection

                                DocumentReference orderDocRef =
                                    await ordersCollection.add({
                                  'buyer id': user.uid,
                                  'date': DateTime.now(),
                                  'items':
                                      cartItems, // Placeholder for the ordered items
                                  'order_status': 'pending',
                                  'seller_id': cartItems[0]['seller_id'],
                                  'time': '',
                                  'payment_id': '0',
                                  'payment_mode': 'cash'
                                });

                                print(
                                    'Order added successfully: ${orderDocRef.id}');
                                // Delete the cart items
                                for (QueryDocumentSnapshot cartItem
                                    in cartDocuments) {
                                  await cartItem.reference.delete();
                                }
                                print('Cart items deleted successfully');
                                Navigator.of(context).pushReplacementNamed(
                                    OrderPlacedScreen.routeName);
                              } catch (e) {
                                print('Failed to add order: $e');
                              }
                            }, // Navigate to OrderPlacedScreen
                            child: Text("Pay on Delivery"),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          CustomNavBar(),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cse_miniproject/const/colors.dart';
// import 'package:cse_miniproject/screens/checkoutScreen.dart';
// import 'package:cse_miniproject/utils/helper.dart';
// import 'package:cse_miniproject/widgets/customNavBar.dart';

// class MyOrderScreen extends StatelessWidget {
//   static const routeName = "/myOrderScreen";

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           icon: Icon(Icons.arrow_back_ios_rounded),
//                         ),
//                         Expanded(
//                           child: Text(
//                             "My Order",
//                             style: Helper.getTheme(context).headline5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('cart')
//                         .where('user_id', isEqualTo: user.uid)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return Text('Error: ${snapshot.error}');
//                       }

//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       }

//                       final cartItems = snapshot.data.docs;
//                       int totalQuantity = 0;
//                       int totalOrders = cartItems.length;
//                       double totalPrice = 0;

//                       for (var item in cartItems) {
//                         final itemName = item['name'] as String;
//                         final itemPrice =
//                             double.tryParse(item['price'] as String);
//                         final quantity = item['quantity'] as int;

//                         if (itemPrice != null) {
//                           totalPrice += itemPrice;
//                         }

//                         if (item['user_id'] == user.uid) {
//                           totalQuantity += quantity;
//                         }
//                       }

//                       return Column(
//                         children: [
//                           ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: cartItems.length,
//                             itemBuilder: (context, index) {
//                               final item = cartItems[index];
//                               final itemName = item['name'] as String;
//                               final itemPrice =
//                                   double.tryParse(item['price'] as String);
//                               final quantity = item['quantity'] as int;

//                               return ListTile(
//                                 title: Text(
//                                   itemName,
//                                   style: TextStyle(
//                                     color: AppColor.primary,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   "Price: ${itemPrice != null ? itemPrice.toString() : ''}",
//                                   style: TextStyle(
//                                     color: AppColor.primary,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                 ),
//                                 trailing: Container(
//                                   width: 50,
//                                   child: TextFormField(
//                                     initialValue: quantity.toString(),
//                                     onChanged: (value) {
//                                       final newQuantity =
//                                           int.tryParse(value) ?? 1;
//                                       // TODO: Update quantity in Firestore
//                                     },
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.symmetric(
//                                         vertical: 8,
//                                         horizontal: 10,
//                                       ),
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           SizedBox(height: 10),
//                           Divider(
//                             color: AppColor.placeholder.withOpacity(0.25),
//                             thickness: 1.5,
//                           ),
//                           SizedBox(height: 10),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         'Total Quantity: $totalQuantity',
//                                         style:
//                                             Helper.getTheme(context).headline3,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         'Total Orders: $totalOrders',
//                                         style:
//                                             Helper.getTheme(context).headline3,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         'Total Price: $totalPrice',
//                                         style:
//                                             Helper.getTheme(context).headline3,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 20),
//                                 SizedBox(
//                                   height: 50,
//                                   width: double.infinity,
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pushNamed(
//                                           CheckoutScreen.routeName,
//                                           arguments: totalPrice);
//                                     },
//                                     child: Text("Checkout"),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           CustomNavBar(),
//         ],
//       ),
//     );
//   }
// }

// class foodCard extends StatefulWidget {
//   const foodCard({
//     Key key,
//     this.name,
//     this.price,
//     this.isLast = false,
//   }) : super(key: key);

//   final String name;
//   final String price;
//   final bool isLast;

//   @override
//   _foodCardState createState() => _foodCardState();
// }

// class _foodCardState extends State<foodCard> {
//   int quantity = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: widget.isLast
//               ? BorderSide.none
//               : BorderSide(
//                   color: AppColor.placeholder.withOpacity(0.25),
//                 ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               "${widget.name} ",
//               style: TextStyle(
//                 color: AppColor.primary,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           Text(
//             "${widget.price}",
//             style: TextStyle(
//               color: AppColor.primary,
//               fontSize: 16,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//           Container(
//             width: 50,
//             child: TextFormField(
//               initialValue: "1",
//               onChanged: (value) {
//                 setState(() {
//                   quantity = int.tryParse(value) ?? 1;
//                 });
//               },
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 10,
//                 ),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
