import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:sam/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/serialnocontroller.dart';
import '../modules/serviceapi.dart';
import '../widgets/appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/snackbar.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController serialController = TextEditingController();
  TextEditingController customercodeController = TextEditingController();
  GlobalKey<FormState> formKey_ = GlobalKey<FormState>();

  final Serialno serialno_ = Get.put(Serialno());
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return Scaffold(
        // backgroundColor: Color.black,
        appBar: const ReusableAppBar(
          title: 'Add Sales',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey_,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,

                    controller: dateController,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter pincode';
                    //   }
                    //   return null;
                    // },
                    onChanged: (Value) {
                      print(dateController.text);
                      if (dateController.text.length == 10) {
                        serialno_.customer_(dateController.text);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: '',
                      suffixIcon: HeroIcon(HeroIcons.calendar),
                      labelText: "Mobile Number",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => SizedBox(
                        height: serialno_.customer.length * 60,
                        child: ListView.builder(
                          itemCount: serialno_.customer.length,
                          itemBuilder: (BuildContext context, index) {
                            return GestureDetector(
                                onTap: () {
                                  customercodeController.text =
                                      serialno_.customer[index]["name"];
                                },
                                child: Card(
                                    child: ListTile(
                                  leading: const HeroIcon(
                                    HeroIcons.user,
                                    size: 25,
                                  ),
                                  title: Text(serialno_.customer[index]
                                          ["customer_name"]
                                      .toString()),
                                )));
                          },
                        ),
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.phone,
                    //                    // autovalidateMode: AutovalidateMode.onUserInteraction,

                    controller: customercodeController,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter pincode';
                    //   }
                    //   return null;
                    // },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: '',
                      suffixIcon: HeroIcon(HeroIcons.calendar),
                      labelText: "Customer Code",
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          // autovalidateMode: AutovalidateMode.onUserInteraction,

                          controller: serialController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter pincode';
                          //   }
                          //   return null;
                          // },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (serialController.text.isNotEmpty) {
                                  String code =
                                      ", Serial Number:${serialController.text.toUpperCase()}";
                                  serialno_.add(code);
                                }
                              },
                              icon: const HeroIcon(
                                HeroIcons.plus,
                                color: Colors.black,
                              ),
                            ),
                            labelText: "Serial No *",
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: IconButton(
                            onPressed: () {
                              Get.toNamed('/qrcode');
                            },
                            icon: const Icon(
                              PhosphorIcons.scan_light,
                              color: Color(0xffe73b18),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(() => SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: serialno_.itemList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final count = index + 1;

                              if (!serialno_.itemList[index]
                                  .containsKey('rate_controller')) {
                                serialno_.itemList[index]['rate_controller'] =
                                    TextEditingController();
                              }
                              return Card(
                                elevation: 6,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8.0),
                                  leading: CircleAvatar(
                                    radius: 15.0,
                                    backgroundColor: const Color(0xfffdebe8),
                                    child: Text(count.toString(),
                                        style: ThemeText.text),
                                  ),
                                  title: Text((serialno_.itemList[index]
                                              ["item_code"] ??
                                          '')
                                      .toString()),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 45,
                                        child: TextField(
                                          textAlign: TextAlign.start,
                                          controller: serialno_.itemList[index]
                                              ['rate_controller'],
                                          onChanged: (newValue) {
                                            setState(() {
                                              serialno_.itemList[index]
                                                      ['rate'] =
                                                  serialno_
                                                      .itemList[index]
                                                          ['rate_controller']
                                                      .text;
                                              print(serialno_.itemList);
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          serialno_.itemDeletion(serialno_
                                              .itemList[index]["item_code"]);
                                        },
                                        icon: const HeroIcon(
                                          HeroIcons.trash,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )),
                  CustomFormButton(
                      innerText: 'Submit',
                      onPressed: (serialno_.itemList.isNotEmpty)
                          ? () {
                              if (formKey_.currentState!.validate()) {
                                salesInvoice(customercodeController.text,
                                    formattedDate, serialno_.itemList);
                              }
                            }
                          : null),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> salesInvoice(customerid, formattedDate, serialno_) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var item in serialno_) {
      item.remove(
          'rate_controller'); // Remove the 'rate_controller' key from the item
    }
    print(serialno_);
    print(prefs.getString('full_name'));
    frappe.call(
        // context: context,
        method:
            "azhagu_murugan_live.azhagu_murugan_live.utils.api.api.sales_invoice_creation",
        args: {
          'data': json.encode({
            "user": "Barath P",
            "customer_name": customerid,
            "posting_date": formattedDate,
            "serial_no": serialno_
          })
        },
        callback: (response, result) async {
          if (response!.statusCode == 200) {
            print(response.statusCode);
            response.headers['cookie'] =
                "${response.headers['set-cookie'].toString()};";
            response.headers.removeWhere(
                (key, value) => ["set-cookie", 'content-length'].contains(key));
            apiHeaders = response.headers;
            await prefs.setString('request-header',
                json.encode(response.headers)); // store headers for API calls
            Get.toNamed("/homepage");
            showCustomSnackBar(
              "Successfully login",
              title: "Success",
              icon: true,
              iconColor: Colors.green,
              backgroundColor: Colors.green.shade700,
            );
          }
        });
  }
}
