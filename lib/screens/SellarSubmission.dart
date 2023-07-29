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

  @override
  Widget build(BuildContext context) {
    bool isSubmitted = false;
    void sendEmail() async {
      final String company = sellerCompany.text;
      final String s_email = sellerEmail.text;
      final String fssai = sellerFssai.text;
      final Email email = Email(
          body:
              "The details to be submitted for the registration<br>Company Name:$company<br>The fssai number: $fssai<br>the email: $s_email",
          subject: "Details",
          recipients: ['homebakersmini@gmail.com'],
          isHTML: true);
      try {
        await FlutterEmailSender.send(email);
        print('Success run');
      } catch (error) {
        print('There is an error:$error');
      } finally {
        Navigator.of(context).pushReplacementNamed(SellerLoginScreen.routeName);
      }
    }

    void submitForm() async {
      await db.collection('seller_submit').doc().set({
        'CompanyName': sellerCompany.text,
        'Email': sellerEmail.text,
        'Fssai': sellerFssai.text
      });
    }

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        onPressed: () {
          Navigator.of(context)
              .pushReplacementNamed(SellerLoginScreen.routeName);
        },
        icon: Icon(
          Icons.arrow_back,
        ),
      )),
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
