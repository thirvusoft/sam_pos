import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import '../modules/serialnocontroller.dart';
import '../widgets/appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/customer_popup.dart';

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
    void showPopup(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupWidget();
        },
      );
    }

    return Scaffold(
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      counterText: '',
                      suffix: IconButton(
                        onPressed: () {
                          showPopup(context);
                        },
                        icon: const HeroIcon(HeroIcons.calendar),
                        color: Colors.black,
                      ),
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
                        child: Container(
                          height: MediaQuery.of(context).size.height / 11.5,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff939393)),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Get.toNamed('/qrcode');
                            },
                            icon: const HeroIcon(
                              HeroIcons.qrCode,
                              size: 25,
                            ),
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
                                  leading: CircleAvatar(
                                    radius: 16,
                                    child: Text(count.toString()),
                                  ),
                                  title: Text((serialno_.itemList[index]
                                              ["item_code"] ??
                                          '')
                                      .toString()),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 35,
                                        child: TextField(
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
                                        onPressed: () {},
                                        icon: const HeroIcon(
                                          HeroIcons.trash,
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
                    onPressed: _handleLoginUser,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _handleLoginUser() {}
}
