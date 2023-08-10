import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../modules/serialnocontroller.dart';
import '../widgets/custom_input_field.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final Serialno serialno_ = Get.put(Serialno());
  @override
  initState() {
    super.initState();
    serialno_.splash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 18, 19, 19),
      backgroundColor: Color.fromARGB(255, 31, 19, 91),
      // rgb(31,19,91)

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "QuickPOS",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            LoadingAnimationWidget.discreteCircle(
                color: Colors.white,
                size: 35,
                secondRingColor: Colors.white,
                thirdRingColor: Colors.white),
          ],
        ),
      ),
    );
  }
}
