import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sam/Pages/qr_border.dart';

class Qrcode extends StatefulWidget {
  const Qrcode({super.key});

  @override
  State<Qrcode> createState() => _QrcodeState();
}

class _QrcodeState extends State<Qrcode> {
  bool iiscanned = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text("Place the QR code in the  area"),
                  Text("Sacnning will be started automatically")
                ])),
            Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    SizedBox(
                      child: MobileScanner(
                        onDetect: (capture) {
                          if (!iiscanned) {
                            String code = "";
                            final List<Barcode> barcodes = capture.barcodes;
                            final Uint8List? image = capture.image;
                            // String code = barcode.rawValue;
                            for (final barcode in barcodes) {
                              code = barcode.rawValue!;
                              debugPrint('Barcode found! ${barcode.rawValue}');
                            }
                          }
                        },
                      ),
                    ),
                    QRScannerOverlay(
                        overlayColour: Colors.black.withOpacity(0.5)),
                  ],
                )),
            Expanded(
                child: Container(
              color: Colors.white,
            )),
          ],
        ),
      ),
    );
  }
}
