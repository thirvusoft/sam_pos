import 'dart:convert';

import 'package:get/get.dart';

import '../widgets/snackbar.dart';

class Serialno extends GetxController {
  List itemList = [].obs;
  List resultList = [];
  bool isDuplicate = false;
  List check_item = [];

  add(itemlist_) {
    List<String> items = itemlist_.split(',');
    Set<String> serialNumbers = {};
    for (String item in items) {
      if (item.contains('Serial Number')) {
        String serialNumber = item.split(':').last.trim();
        print(serialNumber);

        print(itemList);
        if (itemList.isNotEmpty) {
          // for (int i = 0; i < itemList.length; i++) {
          // print("${serialNumber}Serial number");
          // print("${itemList[i]['item_code']}item code");
          print(check_item);
          if (!check_item.contains(serialNumber)) {
            itemList.add(<dynamic, dynamic>{"item_code": serialNumber});
            print("item_list");
            check_item.add(serialNumber);
            print(itemList);
          } else {
            showCustomSnackBar("$serialNumber already exists",
                title: "Success");
          }
        } else {
          print("3");
          check_item.add(serialNumber);
          itemList.add(<dynamic, dynamic>{"item_code": serialNumber});
        }
        break;
      }
    }
  }
}
