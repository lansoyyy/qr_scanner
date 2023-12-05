import 'package:flutter/material.dart';
import 'package:qr_scanner/utils/colors.dart';
import 'package:qr_scanner/widgets/button_widget.dart';
import 'package:qr_scanner/widgets/text_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: TextRegular(
          text: 'SCANNER',
          fontSize: 18,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 250,
            ),
            const SizedBox(
              height: 100,
            ),
            ButtonWidget(
              color: primary,
              radius: 1000,
              label: 'Scan',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
