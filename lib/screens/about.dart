import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainAbout extends StatefulWidget {
  const MainAbout({super.key});

  @override
  State<MainAbout> createState() => _MainAboutState();
}

class _MainAboutState extends State<MainAbout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: const [
                  SizedBox(height: 8),
                  Text(
                    "About Our App:",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                      "Welcome to our innovative application designed to simplify and enhance your online shopping experience! Our app is dedicated to keeping you updated with the latest product prices from various external websites, seamlessly integrated into your preferred online platform."),
                  SizedBox(height: 18),
                  Text(
                    "What We Offer:",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                      "Our mission is to provide you with real-time price updates for a wide range of products, all conveniently displayed on your chosen website. Through the power of cutting-edge technology, we ensure that you never miss out on the best deals and offers available in the market."),
                  SizedBox(height: 18),
                  Text(
                    "How It Works:",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                      "By granting us access to specific information from your website, such as your domain and web service token, we create a seamless connection that allows us to regularly fetch and update product prices. This automation saves you valuable time and effort, as you no longer need to manually track and input price changes."),
                  SizedBox(height: 18),
                  Text(
                    "Why Choose Our App:",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                      "Efficiency: Our app streamlines the process of price updates, freeing you from the hassle of manual data entry.\n\nAccuracy: With our automated system, you can trust that the prices displayed are always up-to-date and accurate.\n\nCustomization: Tailor the settings to match your preferences and seamlessly integrate our app into your existing workflow."),
                  SizedBox(height: 18),
                  Text(
                    "Your Data's Security:",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                      "We understand the importance of your data's security and privacy. Rest assured that we handle your provided information with the utmost care, implementing robust encryption and security measures to protect your data."),
                  SizedBox(height: 18),
                  Text(
                    "Get Started:",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                      "Experience the future of online shopping today! Simply provide us with the necessary details, such as your domain and web service token, to initiate the connection. Once connected, you'll have a front-row seat to the dynamic world of real-time price updates.\n\nShould you have any questions or require assistance, our dedicated support team is ready to help. Thank you for choosing our app to elevate your online shopping journey!"),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Contact us",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () async {
                          String url = "tg://resolve?domain=ASamavi";
                          if (!await launchUrl(Uri.parse(url))) {
                            throw Exception("Could not launch $url");
                          }
                        },
                        child: Image.asset(
                          "assets/images/telegram.svg.png",
                          height: 100,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          String url = "https://github.com/AliSamavi";
                          if (!await launchUrl(Uri.parse(url))) {
                            throw Exception("Could not launch $url");
                          }
                        },
                        child: Image.asset(
                          "assets/images/github.svg.png",
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
