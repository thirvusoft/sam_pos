import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sam/modules/serviceapi.dart';
import 'package:sam/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Pages/home_page.dart';
import '../Pages/login_page.dart';
import '../widgets/appbar.dart';
import '../widgets/snackbar.dart';

class Serialno extends GetxController {
  List itemList = <dynamic>[].obs;
  List customer = [].obs;
  List resultList = [];
  bool isDuplicate = false;
  List check_item = [];
  late Timer timer;

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
                title: "Failure", icon: false);
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
    print(itemList);
  }

  empty() {
    print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
    itemList.clear();
    customer.clear();
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

  Future customer_(number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    frappe.call(
        // context: context,
        method:
            "azhagu_murugan_live.azhagu_murugan_live.utils.api.api.customer_list",
        args: {
          "mobile": number,
        },
        callback: (response, result) async {
          if (response!.statusCode == 200) {
            customer.clear();
            print(response.statusCode);

            print(result?["message"]);
            customer += result?["message"] ?? [];
            response.headers['cookie'] =
                "${response.headers['set-cookie'].toString()};";
            response.headers.removeWhere(
                (key, value) => ["set-cookie", 'content-length'].contains(key));
            apiHeaders = response.headers;
            await prefs.setString('request-header',
                json.encode(response.headers)); // store headers for API calls
          }
        });
  }

  Future splash() async {
    await frappe.call(
        method: "frappe.auth.get_logged_user",
        callback: (response, result) async {
          if (response!.statusCode == 200) {
            timer = Timer(
                const Duration(seconds: 3), () => Get.offAllNamed('/homepage'));
          }
        });
  }
}
