import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sam/modules/serviceapi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/snackbar.dart';

class Serialno extends GetxController {
  List itemList = [].obs;
  List resultList = [];
  bool isDuplicate = false;
  List check_item = [];

  add(itemlist_) {
    List<String> items = itemlist_.split(',');
    for (String item in items) {
      if (item.contains('Serial Number')) {
        String serialNumber = item.split(':').last.trim();
        print(serialNumber);

        print(itemList);
        if (itemList.isNotEmpty) {
          print(check_item);
          if (!check_item.contains(serialNumber)) {
            itemList.add(<dynamic, dynamic>{"item_code": serialNumber});
            print("item_list");
            check_item.add(serialNumber);
            print(itemList);
          } else {
            showCustomSnackBar("$serialNumber already exists",
                title: "Success", icon: false);
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

  itemDeletion(index) {
    itemList.removeWhere((item) => item['item_code'] == index);
  }

  Future salesInvoice(email, pwd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await http.get(
        Uri.parse(
          "https://sam2.thirvusoft.co.in/api/method/login?usr=$email&pwd=$pwd",
        ),
      );
      print(response.statusCode);
      print(response.body);
      response.headers['cookie'] =
          "${response.headers['set-cookie'].toString()};";
      response.headers.removeWhere(
          (key, value) => ["set-cookie", 'content-length'].contains(key));
      apiHeaders = response.headers;
      await prefs.setString('request-header',
          json.encode(response.headers)); // store headers for API calls

      print(prefs.getString('request-header') ?? '');
    } catch (e) {
      print('Error fetching events: $e');
    }
  }
}
