import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sam/modules/serialnocontroller.dart';
import 'package:searchfield/searchfield.dart';
import 'appbar.dart';
import 'custom_button.dart';
import 'custom_input_field.dart';

class PopupWidget extends StatefulWidget {
  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

List<String> list = <String>['B2C', 'B2B'];

class _PopupWidgetState extends State<PopupWidget> {
  final Serialno serialno_ = Get.put(Serialno());

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      title: const Text('Customer Creation'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Customer Group",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: dropdownValue,
                    decoration: const InputDecoration(),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CustomInputField(
              controller: customernameController,
              keyboardType: false,
              labelText: 'Customer Name',
              hintText: '',
              validator: (textValue) {
                if (textValue == null || textValue.isEmpty) {
                  return 'Customer name is required!';
                }
                return null;
              },
            ),
            CustomInputField(
              controller: mobileNoController,
              labelText: 'Mobile Number',
              hintText: '',
              keyboardType: true,
              validator: (textValue) {
                if (textValue == null || textValue.isEmpty) {
                  return 'Mobile number is required!';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Territory",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Obx(() => SearchField(
                        controller: territoryController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select State';
                          }
                          if (!territory.contains(value)) {
                            return 'State not found';
                          }
                          return null;
                        },
                        suggestions: serialno_.territorylist_
                            .map((String) => SearchFieldListItem(String))
                            .toList(),
                        suggestionState: Suggestion.expand,
                        suggestionsDecoration: SuggestionDecoration(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 5, bottom: 20),
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        textInputAction: TextInputAction.next,
                        marginColor: Colors.white,
                        searchStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.8),
                        ),
                        onSearchTextChanged: (p0) {
                          print(territoryController.text);
                          serialno_.territory(territoryController.text);
                          print("chgcychjcjhchchgchgcgcgh");
                          print(serialno_.territorylist_);
                        },
                        searchInputDecoration: const InputDecoration(),
                      )),
                ],
              ),
            ),
            Visibility(
              visible: dropdownValue == 'B2B',
              child: Column(
                children: [
                  CustomInputField(
                    keyboardType: false,
                    controller: addressline1Controller,
                    labelText: 'Address Line 1',
                    hintText: '',
                    validator: (textValue) {
                      if (textValue == null || textValue.isEmpty) {
                        return 'Address Line 1 is required!';
                      }
                      return null;
                    },
                  ),
                  CustomInputField(
                    keyboardType: false,
                    controller: addressline2Controller,
                    labelText: 'Address Line 2',
                    hintText: '',
                    validator: (textValue) {
                      if (textValue == null || textValue.isEmpty) {
                        return 'Address Line 2 is required!';
                      }
                      return null;
                    },
                  ),
                  CustomInputField(
                    keyboardType: false,
                    controller: gstnController,
                    labelText: 'GSTN',
                    hintText: '',
                    validator: (textValue) {
                      if (textValue == null || textValue.isEmpty) {
                        return 'GSTN is required!';
                      }
                      return null;
                    },
                  ),
                  CustomInputField(
                    keyboardType: false,
                    controller: cityController,
                    labelText: 'City',
                    hintText: '',
                    validator: (textValue) {
                      if (textValue == null || textValue.isEmpty) {
                        return 'City is required!';
                      }
                      return null;
                    },
                  ),
                  CustomInputField(
                    keyboardType: true,
                    controller: pincodeController,
                    labelText: 'Pincode',
                    hintText: '',
                    validator: (textValue) {
                      if (textValue == null || textValue.isEmpty) {
                        return 'Pincode is required!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            CustomFormButton(
                innerText: 'Submit',
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  serialno_.customercreation_({
                    "customer_name": customernameController.text,
                    "mobile_no": mobileNoController.text,
                    "customer_group": dropdownValue,
                    "territory": territoryController.text,
                    "ts_address_line1": addressline1Controller.text,
                    "ts_address_line2": addressline2Controller.text,
                    "ts_city": cityController.text,
                    "ts_state": "Tamil Nadu",
                    "ts_pin_code": pincodeController.text,
                    "ts_gstin": gstnController.text,
                    "email_id": ""
                  });
                }),
          ],
        ),
      ),
    );
  }
}
