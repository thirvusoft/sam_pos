import 'package:flutter/material.dart';

class PopupWidget extends StatefulWidget {
  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

List<String> list = <String>['B2B', 'B2C'];

class _PopupWidgetState extends State<PopupWidget> {
  TextEditingController customernameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();

  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        title: const Text(
          'Customer Creation',
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: customernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  counterText: '',
                  labelText: "Customer Name *",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: mobileNoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  counterText: '',
                  labelText: "Mobile No *",
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: dropdownValue,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  counterText: '',
                  labelText: "Customer Group",
                ),
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
              )
            ],
          ),
        ));
  }
}
