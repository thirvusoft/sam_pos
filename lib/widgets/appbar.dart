import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/serialnocontroller.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  ReusableAppBar({super.key, required this.title, this.actions});
  final Serialno serialno_ = Get.put(Serialno());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          onPressed: () {
            serialno_.logout();
          },
        )
      ],
      title: Text(title),
      centerTitle: true,
      // actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

List territory = [];
TextEditingController customernameController = TextEditingController();
TextEditingController mobileNoController = TextEditingController();
TextEditingController territoryController = TextEditingController();
TextEditingController addressline1Controller = TextEditingController();
TextEditingController addressline2Controller = TextEditingController();
TextEditingController gstnController = TextEditingController();
TextEditingController cityController = TextEditingController();
TextEditingController pincodeController = TextEditingController();
