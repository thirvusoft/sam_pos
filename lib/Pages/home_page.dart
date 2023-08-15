import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/serialnocontroller.dart';
import '../routes/routes.dart';
import '../widgets/appbar.dart';
import '../widgets/custom_button.dart';

import '../widgets/custom_input_field.dart';
import 'package:intl/intl.dart';

import '../widgets/customer_popup.dart';
import 'orderpreview.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GlobalKey<FormState> formKey_ = GlobalKey<FormState>();
  var customername_ = "";
  var customernumber_ = "";
  final Serialno serialno_ = Get.put(Serialno());
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    void showPopup(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupWidget();
        },
      );
    }

    return Scaffold(
        // backgroundColor: Color.black,
        // backgroundColor: Color.black,
        appBar: ReusableAppBar(
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
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: dateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Mobile Number';
                      }
                      return null;
                    },
                    onChanged: (Value) {
                      if (dateController.text.length == 10) {
                        serialno_.customer_(dateController.text);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: '',
                      suffixIcon: HeroIcon(HeroIcons.phone,
                          color: Color.fromARGB(255, 245, 94, 60)),
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
                                  customername_ = serialno_.customer[index]
                                          ["customer_name"]
                                      .toString();
                                  print(customername_);
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: customercodeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Customer Code';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          showPopup(context);
                        },
                        icon: const HeroIcon(HeroIcons.userPlus,
                            color: Color.fromARGB(255, 245, 94, 60)),
                      ),
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
                                  // String code =
                                  //     ", Serial Number:${serialController.text.toUpperCase()}";
                                  serialno_.serialno_(
                                      serialController.text.toUpperCase());
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
                              color: Color.fromARGB(255, 245, 94, 60),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(() => SizedBox(
                        height: serialno_.itemList.length * 99,
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
                              } else {
                                serialno_.itemList[index]['rate_controller']
                                        .value =
                                    TextEditingValue(
                                        text: serialno_
                                            .itemList[index]['rate_controller']
                                            .text,
                                        selection: TextSelection.collapsed(
                                            offset: serialno_
                                                .itemList[index]
                                                    ['rate_controller']
                                                .text
                                                .toString()
                                                .length));
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
                                  subtitle: Text(
                                      "Item Code : ${serialno_.itemList[index]["item_name"] ?? ''}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 45,
                                        child: TextField(
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
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
                                salesInvoice(
                                    customercodeController.text,
                                    formattedDate,
                                    serialno_.itemList,
                                    customername_,
                                    dateController.text);
                              }
                            }
                          : null),
                ],
              ),
            ),
          ),
        ));
  }

  salesInvoice(customerid, formattedDate, serialno_, customername_,
      customernumber_) async {
    serialController.clear();
    Get.to(Orderpreview(), arguments: [
      serialno_,
      customerid,
      formattedDate,
      customername_,
      customernumber_
    ]);

    temp() {
      serialno_.empty();
    }
  }
}
