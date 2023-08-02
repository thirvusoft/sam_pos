import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/serialnocontroller.dart';
import '../modules/serviceapi.dart';
import '../widgets/appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/snackbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController dateController = TextEditingController();
    TextEditingController serialController = TextEditingController();
    final Serialno serialno_ = Get.put(Serialno());
    return Scaffold(
        // backgroundColor: Color.black,
        appBar: const ReusableAppBar(
          title: 'Add Sales',
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                    onChanged: (Value) {
                      print(dateController.text);
                      if (dateController.text.length == 10) {

                        
                      }
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
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: serialController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter pincode';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (serialController.text.isNotEmpty) {
                                  String code =
                                      ", Serial Number:${serialController.text}";
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
                          icon: const HeroIcon(
                            HeroIcons.qrCode,
                            size: 25,
                          ),
                        ),
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
                      innerText: 'Login',
                      onPressed: () {
                        salesInvoice();
                      }),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> salesInvoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    frappe.call(
        method: "login",
        // args: {"usr": email, "pwd": pwd},
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

            frappe.call(
                // context: context,
                method: "login",
                args: {"usr": "vignesh@thirvusoft.in", "pwd": "admin@123"},
                callback: (response, result) async {
                  if (response!.statusCode == 200) {
                    print(response.statusCode);
                    response.headers['cookie'] =
                        "${response.headers['set-cookie'].toString()};";
                    response.headers.removeWhere((key, value) =>
                        ["set-cookie", 'content-length'].contains(key));
                    apiHeaders = response.headers;
                    await prefs.setString(
                        'request-header',
                        json.encode(
                            response.headers)); // store headers for API calls
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
        });
  }
}
