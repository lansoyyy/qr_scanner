import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_scanner/utils/colors.dart';
import 'package:qr_scanner/widgets/button_widget.dart';
import 'package:qr_scanner/widgets/text_widget.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String qrCode = 'Unknown';
  String name = '';
  int persons = 0;
  String ride = '';

  Future<void> scanQRCode() async {
    String status = '';
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });
      print('id $qrCode');

      await FirebaseFirestore.instance
          .collection('Rides')
          .doc(qrCode)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          setState(() {
            status = documentSnapshot['status'];
            persons = documentSnapshot['persons'];
            name = documentSnapshot['name'];
            ride = documentSnapshot['ride'];
          });
        }

        Navigator.pop(context);

        if (status == 'Pending') {
          await FirebaseFirestore.instance
              .collection('Rides')
              .doc(qrCode)
              .update({'status': 'Done'});

          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.success,
            body: Center(
              child: TextBold(
                text:
                    'QR Scanned succesfully!\nName: $name\nRide: $ride\nPersons: $persons',
                fontSize: 18,
                color: Colors.green,
              ),
            ),
            btnOkOnPress: () {},
          ).show();
        } else {
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            body: Center(
              child: TextBold(
                text:
                    'QR Scanned unsuccesfully!\nThis ticket has already been used.',
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            btnOkOnPress: () {},
          ).show();
        }
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

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
              onPressed: () {
                // AwesomeDialog(
                //   context: context,
                //   animType: AnimType.scale,
                //   dialogType: DialogType.ERROR,
                //   body: Center(
                //     child: TextBold(
                //       text: 'QR Scanned unsuccesfully!',
                //       fontSize: 18,
                //       color: Colors.red,
                //     ),
                //   ),
                //   title: 'This is Ignored',
                //   desc: 'This is also Ignored',
                //   btnCancelOnPress: () {},
                // ).show();
                scanQRCode();
              },
            ),
          ],
        ),
      ),
    );
  }
}
