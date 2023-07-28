import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/SellerloginScreen.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth firebase = FirebaseAuth.instance;
final TextEditingController sellerEmail = TextEditingController();
final TextEditingController sellerCompany = TextEditingController();
final TextEditingController sellerFssai = TextEditingController();

class SellerSubmit extends StatelessWidget {
  const SellerSubmit({Key key}) : super(key: key);
  static const routeName = '/SellerSubmit';
  void sendEmail() async {
    final Email email = Email(
        body:
            "here are the details of ${sellerCompany},fssai number: ${sellerFssai},email: ${sellerEmail}",
        subject: "Details",
        recipients: ['homebakersmini@gmail.com'],
        isHTML: false);
    try {
      await FlutterEmailSender.send(email);
      print('Success run');
    } catch (error) {
      print('There is an error:$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSubmitted = false;
    void submitForm() async {
      await db.collection('seller_submit').doc().set({
        'CompanyName': sellerCompany.text,
        'Email': sellerEmail.text,
        'Fssai': sellerFssai.text
      });
      showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text('Successfully Submitted'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () {
        Navigator.of(context).pushReplacementNamed(SellerLoginScreen.routeName);
      })),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
                child: Center(
                  child: Text(
                    'Welcome Chef',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: Text('Email'),
              ),
              TextField(
                controller: sellerEmail,
              ),
              Spacer(),
              Center(
                child: Text('Company Name'),
              ),
              TextField(
                controller: sellerCompany,
              ),
              Spacer(),
              Center(
                child: Text('Fssai Number'),
              ),
              TextField(
                controller: sellerFssai,
              ),
              Spacer(),
              SizedBox(
                child: Center(
                    child: ElevatedButton(
                  onPressed: () {
                    sendEmail();
                  },
                  child: Center(child: Text('Submit')),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
