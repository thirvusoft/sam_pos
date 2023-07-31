import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import '../widgets/appbar.dart';
import '../widgets/custom_input_field.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController dateController = TextEditingController();
    TextEditingController serialController = TextEditingController();
    return Scaffold(
      appBar: const ReusableAppBar(
        title: 'Add Sales',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: dateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pincode';
                }

                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: '',
                suffixIcon: HeroIcon(HeroIcons.calendar),
                labelText: "Customer *",
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: serialController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pincode';
                }

                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    Get.toNamed('/qrcode');
                  },
                  icon: const HeroIcon(HeroIcons.qrCode),
                ),
                labelText: "Serial No *",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        )),
      ),
    );
  }
}
