import 'package:flutter/material.dart';
import 'package:cse_miniproject/const/colors.dart';
import 'package:cse_miniproject/utils/helper.dart';
import 'package:cse_miniproject/widgets/customNavBar.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = "/aboutScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "About Us",
                          style: Helper.getTheme(context).headline5,
                        ),
                      ),
                      Image.asset(
                        Helper.getAssetName("cart.png", "virtual"),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  AboutCard(
                    text:
                        "At Homely, we are passionate about homemade food and the joy it brings. Our mission is to connect food enthusiasts with talented home bakers who create delicious treats with love and care. We believe in supporting local businesses and promoting the art of baking in our community.",
                  ),
                  SizedBox(height: 20),
                  // AboutCard(
                  //   text: "Additional information goes here.",
                  // ),
                  // SizedBox(height: 20),
                  // AboutCard(
                  //   text: "More details can be added in this section.",
                  // ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomNavBar(
              menu: true,
            ),
          ),
        ],
      ),
    );
  }
}

class AboutCard extends StatelessWidget {
  final String text;

  const AboutCard({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: AppColor.orange,
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: AppColor.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
