import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/serialnocontroller.dart';

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
    print("initState Called");
    serialno_.splash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
