import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../modules/serialnocontroller.dart';

class Qrcode extends StatefulWidget {
  const Qrcode({super.key});

  @override
  State<Qrcode> createState() => _QrcodeState();
}

class _QrcodeState extends State<Qrcode> {
  final Serialno serialno_ = Get.put(Serialno());

  Barcode? result;

  bool iiscanned = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String username = '';
  var itemlist_;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

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
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.white,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 250,
                      ),
                    ),
                    // QRScannerOverlay(
                    //     overlayColour: Colors.black.withOpacity(0.5)),
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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result!.code!.isNotEmpty) {
          setState(() {
            itemlist_ = result!.code.toString();
          });
          controller.pauseCamera();
          print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
          print(itemlist_);
          Get.toNamed('/homepage');
          serialno_.add(itemlist_);
          // itemlist.add(itemlist_);
        }
      });
    });
  }
}
