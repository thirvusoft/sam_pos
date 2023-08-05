import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sam/modules/serviceapi.dart';
import 'package:sam/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/appbar.dart';
import '../widgets/snackbar.dart';

class Serialno extends GetxController {
  List itemList = <dynamic>[].obs;
  List customer = [].obs;
  List territorylist_ = [].obs;
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

  Future territory(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    frappe.call(
        // context: context,
        method: "frappe.desk.search.search_link",
        args: {
          "txt": name,
          "doctype": "Territory",
          "ignore_user_permissions": "1",
          "reference_doctype": "Customer"
        },
        callback: (response, result) async {
          if (response!.statusCode == 200) {
            customer.clear();
            print(response.statusCode);

            print(result?["results"]);
            List<String> valuesList = [];

            for (var item in result?["results"]) {
              if (item.containsKey('value')) {
                print(item['value']);
                valuesList.add(item['value']);
              }
            }
            territorylist_ += (valuesList);

            print("[[][][][][][][][][][][][][]]");
            print(territorylist_);
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

  Future customercreation_(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    frappe.call(
        // context: context,
        method:
            "azhagu_murugan_live.azhagu_murugan_live.utils.api.api.customer_creation",
        args: {'data': json.encode(name)},
        callback: (response, result) async {
          if (response!.statusCode == 200) {
            customernameController.clear();
            mobileNoController.clear();
            territoryController.clear();
            addressline1Controller.clear();
            addressline2Controller.clear();
            pincodeController.clear();
            customernameController.clear();
            Get.back();

            showCustomSnackBar(
              result?["message"],
              title: "Success",
              icon: true,
              iconColor: Colors.green,
              backgroundColor: Colors.green.shade700,
            );
            response.headers['cookie'] =
                "${response.headers['set-cookie'].toString()};";
            response.headers.removeWhere(
                (key, value) => ["set-cookie", 'content-length'].contains(key));
            apiHeaders = response.headers;
            await prefs.setString('request-header',
                json.encode(response.headers)); // store headers for API calls
          } else {
            showCustomSnackBar(
              result?["message"],
              title: "Failure",
              icon: false,
              iconColor: Colors.white,
              backgroundColor: Colors.red.shade700,
            );
          }
        });
  }

  Future logout() async {
    await frappe.call(
        method: "logout",
        callback: (response, result) async {
          if (response!.statusCode == 200) {
            
            timer = Timer(const Duration(seconds: 2),
                () => Get.offAllNamed('/loginpage'));
          }
        });
  }
}
