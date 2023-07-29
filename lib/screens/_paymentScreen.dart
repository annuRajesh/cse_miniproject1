import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cse_miniproject/const/colors.dart';
// import 'package:cse_miniproject/utils/helper.dart';
// import 'package:cse_miniproject/widgets/customNavBar.dart';
// import 'package:cse_miniproject/widgets/customTextInput.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = "/paymentScreen";
  final double totalPrice; // Add totalPrice as a parameter

  PaymentScreen({this.totalPrice});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orders');

    CollectionReference cartCollection =
        FirebaseFirestore.instance.collection('cart');

    QuerySnapshot querySnapshot =
        await cartCollection.where('user_id', isEqualTo: user.uid).get();

    List<QueryDocumentSnapshot> cartItems = querySnapshot.docs;

    // Create an order document in the orders collection
    DocumentReference orderDocRef = await ordersCollection.add({
      'buyer_id': user.uid,
      'date': DateTime.now(),
      'items': [], // Placeholder for the ordered items
      'order_status': '',
      'seller_id': cartItems[0]['seller_id'],
      'time': '',
      'payment_id': '${response.paymentId}',
      'payment_mode': 'online'
    });

    for (var cartItem in cartItems) {
      // Get the data from the cart item
      Map<String, dynamic> cartData = cartItem.data();

      // Create an ordered item document in the ordered items collection
      await orderDocRef.collection('items').add({
        'product_id': cartData['product_id'],
        'quantity': cartData['quantity'],
        'timestamp': cartData['timestamp']
      });

      // Delete the cart item from the cart collection
      await cartCollection.doc(cartItem.id).delete();
    }

    print("Payment Successful. Payment ID: ${response.paymentId}");

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Success()),
    // );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print("Payment Failed. Error: ${response.message}");
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Unsuccessful()),
    // );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print("External Wallet: ${response.walletName}");
  }

  void _openRazorpayCheckout() {
    var options = {
      'key': 'rzp_test_n1O2UDFsR1lBVr',
      'amount': (widget.totalPrice * 100)
          .toInt(), // amount in paise (Example: 1INR = 100 paise)
      'name': 'Passify',
      'description': 'Ticket price',
      'prefill': {'contact': '9876543210', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm', 'googlepay']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set the desired background color
        title: Text(
          'Payment',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0), // Set the text color
            fontSize: 25, // Set the text font size
            fontWeight: FontWeight.bold, // Set the text font weight
          ),
        ), // Center align the title
        elevation: 4, // Remove the elevation shadow
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade200,
                    Colors.purple.shade50,
                  ],
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/123.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ), // Add padding to the container
            ),
          ),
          Center(
            child: Container(
              width: 200, // Set the desired width
              height: 50, // Set the desired height
              child: ElevatedButton(
                onPressed: _openRazorpayCheckout,
                child: Text('Pay with Razorpay'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
