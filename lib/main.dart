import 'package:cse_miniproject/screens/SellerOrdersStateScreen.dart';
import 'package:flutter/material.dart';
import 'package:cse_miniproject/screens/EnterFood.dart';
import 'package:cse_miniproject/screens/SellarSubmission.dart';
import 'package:cse_miniproject/screens/SellerOrdersScreen.dart';
import 'package:cse_miniproject/screens/Seller_intro.dart';
import 'package:cse_miniproject/screens/SellerloginScreen.dart';
import 'package:cse_miniproject/screens/changeAddressScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cse_miniproject/screens/foodList.dart';
import 'package:cse_miniproject/screens/readReview.dart';
import 'package:cse_miniproject/screens/sellar_signUpScreen.dart';
import 'package:cse_miniproject/screens/seller_foodlist.dart';
// import 'firebase_options.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_service.dart';
import './screens/spashScreen.dart';
import './screens/landingScreen.dart';
import './screens/loginScreen.dart';
import './screens/signUpScreen.dart';
import './screens/forgetPwScreen.dart';
import './screens/sentOTPScreen.dart';
import './screens/newPwScreen.dart';
import './screens/introScreen.dart';
import './screens/homeScreen.dart';
import './screens/menuScreen.dart';
import './screens/moreScreen.dart';
import './screens/offerScreen.dart';
import './screens/profileScreen.dart';
import './screens/dessertScreen.dart';
import './screens/individualItem.dart';
import './screens/paymentScreen.dart';
import './screens/notificationScreen.dart';
import './screens/aboutScreen.dart';
import './screens/inboxScreen.dart';
import './screens/myOrderScreen.dart';
import './screens/checkoutScreen.dart';
import './screens/OrderPlacedScreen.dart';
import './const/colors.dart';
import './firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './screens/sellar_signUpScreen.dart';

//const primaryColor = Color.fromARGB(255, 71, 203, 97);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ignore: non_constant_identifier_names
  //Initialize Firebase;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Metropolis",
        primarySwatch: Colors.lightGreen,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
            shape: MaterialStateProperty.all(
              StadiumBorder(),
            ),
            elevation: MaterialStateProperty.all(0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              Colors.lightGreen,
            ),
          ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.green),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the desired icon color
        ),
        textTheme: TextTheme(
          headline3: TextStyle(
            color: AppColor.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            color: AppColor.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          headline5: TextStyle(
            color: AppColor.primary,
            fontWeight: FontWeight.normal,
            fontSize: 25,
          ),
          headline6: TextStyle(
            color: AppColor.primary,
            fontSize: 25,
          ),
          bodyText2: TextStyle(
            color: AppColor.secondary,
          ),
        ),
      ),
      home: SplashScreen(),
      routes: {
        LandingScreen.routeName: (context) => LandingScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        SendOTPScreen.routeName: (context) => SendOTPScreen(),
        NewPwScreen.routeName: (context) => NewPwScreen(),
        IntroScreen.routeName: (context) => IntroScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        MenuScreen.routeName: (context) => MenuScreen(),
        OfferScreen.routeName: (context) => OfferScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        MoreScreen.routeName: (context) => MoreScreen(),
        CatagoryScreen.routeName: (context) => CatagoryScreen(),
        IndividualItem.routeName: (context) => IndividualItem(),
        PaymentScreen.routeName: (context) => PaymentScreen(),
        NotificationScreen.routeName: (context) => NotificationScreen(),
        AboutScreen.routeName: (context) => AboutScreen(),
        InboxScreen.routeName: (context) => InboxScreen(),
        MyOrderScreen.routeName: (context) => MyOrderScreen(),
        CheckoutScreen.routeName: (context) => CheckoutScreen(),
        ChangeAddressScreen.routeName: (context) => ChangeAddressScreen(),
        FoodList.routeName: (context) => FoodList(),
        SellerSubmit.routeName: (context) => SellerSubmit(),
        SellerSignUpScreen.routeName: (context) => SellerSignUpScreen(),
        SellerLoginScreen.routeName: (context) => SellerLoginScreen(),
        sellerIntro.routeName: (context) => sellerIntro(),
        EnterFood.routeName: (context) => EnterFood(),
        SellerFoodList.routeName: (context) => SellerFoodList(),
        OrderPlacedScreen.routeName: (context) => OrderPlacedScreen(),
        ReadReview.routeName: (context) => ReadReview(),
        SellerOrdersScreen.routeName: (context) => SellerOrdersScreen(),
        SellerStateOrdersScreen.routeName: (context) =>
            SellerStateOrdersScreen()
      },
    );
  }
}
