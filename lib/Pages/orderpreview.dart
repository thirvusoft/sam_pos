import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/serviceapi.dart';

import '../modules/serialnocontroller.dart';
import '../routes/routes.dart';
import '../widgets/appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/snackbar.dart';

class Orderpreview extends StatefulWidget {
  const Orderpreview({super.key});

  @override
  State<Orderpreview> createState() => _OrderpreviewState();
}

class _OrderpreviewState extends State<Orderpreview> {
  List arguments = Get.arguments;
  final Serialno serialno_ = Get.put(Serialno());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ReusableAppBar(
          title: 'Order View',
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Customer name :${arguments[3]}",
                )),
                Expanded(child: Text("Customer Code :${arguments[1]}"))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text("Mobile Number : ${arguments[4]}"),
            const SizedBox(
              height: 10,
            ),
            (arguments[0].length != 0)
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 12,
                    decoration: BoxDecoration(
                      color: const Color(
                          0xffedeafb), // Replace with the desired background color
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius value as needed
                    ),
                    child: const Center(
                      child: Text("Selected Product",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5)),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: arguments[0].length.toDouble() * 99,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: arguments[0].length,
                itemBuilder: (BuildContext context, int index) {
                  final count = index + 1;

                  return ListTile(
                      title: Text(arguments[0][index]["item_code"]),
                      leading: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: const Color(0xfffdebe8),
                        child: Text(count.toString(), style: ThemeText.text),
                      ),
                      subtitle: Text(
                          "Item Code : ${arguments[0][index]["item_name"] ?? ''}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 45,
                            child: Text(
                                "₹ : ${arguments[0][index]["rate"] ?? ''}"),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                arguments[0].removeAt(index);
                              });

                              serialno_.itemDeletion(
                                  serialno_.itemList[index]["item_code"]);
                            },
                            icon: const HeroIcon(
                              HeroIcons.trash,
                              color: Colors.black,
                              size: 25,
                            ),
                          ),
                        ],
                      ));
                },
              ),
            ),
            CustomFormButton(
                innerText: 'Submit',
                onPressed: () {
                  salesInvoice(arguments[1], arguments[2], arguments[0]);
                }),
          ]),
        ));
  }

  salesInvoice(
    customerid,
    formattedDate,
    serialno_,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(customerid);
    print(formattedDate.toString());
    print("before");
    print(serialno_);
    for (var item in serialno_) {
      item.remove('rate_controller');
    }
    print("after");
    print(serialno_);
    frappe.call(
        method:
            "azhagu_murugan_live.azhagu_murugan_live.utils.api.api.sales_invoice_creation",
        args: {
          'data': json.encode({
            "user": prefs.getString('full_name') ?? "",
            "customer_name": customerid,
            "posting_date": formattedDate,
            "serial_no": serialno_
          })
        },
        callback: (response, result) async {
          print(result);
          print(response!.statusCode);
          if (response!.statusCode == 200) {
            temp();
            response.headers['cookie'] =
                "${response.headers['set-cookie'].toString()};";
            response.headers.removeWhere(
                (key, value) => ["set-cookie", 'content-length'].contains(key));
            apiHeaders = response.headers;
            await prefs.setString('request-header',
                json.encode(response.headers)); // store headers for API calls
            dateController.clear();
            serialController.clear();
            customercodeController.clear();
            showCustomSnackBar(
              result?['message'],
              title: "Success",
              icon: true,
              iconColor: Colors.white,
              backgroundColor: Colors.green.shade700,
            );
          } else {
            showCustomSnackBar(
              result?['message'],
              title: "Failure",
              icon: false,
              iconColor: Colors.white,
              backgroundColor: Colors.red.shade700,
            );
          }
        });
  }

  temp() {
    serialno_.empty();
  }
}
