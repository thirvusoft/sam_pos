import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Map<String, String> apiHeaders = {'Content-Type': 'application/json'};

class Undefined {}

bool isDefinedAndNotNull(dynamic value) {
  return value != null && value != Undefined;
}

class frappe {
  static Future<void> call(
      {required String method,
      Map<dynamic, dynamic> args = const {},
      void Function(http.StreamedResponse?, Map<dynamic, dynamic>?)?
          callback}) async {
    if (apiHeaders.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if ((prefs.getString('request-header') ?? "").toString().isNotEmpty) {
        json
            .decode(prefs.getString('request-header').toString())
            .forEach((k, v) => {apiHeaders[k.toString()] = v.toString()});
      }
    }
    String url = "https://sam2.thirvusoft.co.in";
    var request = http.Request(
      'GET',
      Uri.parse("""https://sam2.thirvusoft.co.in/api/method/$method"""),
    );
    print(args);
    print(request.body);
    request.body = json.encode(args);
    print("--------------");
    print(request);
    print(request.body);

    request.headers.addAll(apiHeaders);
    print('--------------------BEFORE $method---------------------------');
    http.StreamedResponse response = await request.send();
    print('--------------------REQUEST $method---------------------------');

    var res = json.decode(await response.stream.bytesToString());
    print(response.statusCode);
    print(res);

    callback?.call(response, res);
    // if (isDefinedAndNotNull(res?['show_alert'])) {
    //   showAlert(res?['show_alert']);
    // }
    // if (pushSessionExpiryScreen &&
    //     (res?['session_expired'] == 1 ||
    //         !response.headers.toString().contains("system_user=yes"))) {

    //   return;
    // }
  }

  static void showAlert(args) {
    if (args is String) {
      try {
        args = json.decode(args);
      } finally {}
    }
    if (isDefinedAndNotNull(args?['message'])) {
      print("pppppp");
      print((args?['message'] ?? '').toString());
      // Fluttertoast.showToast(
      //     msg: (args?['message'] ?? '').toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: (const {
      //           'red': Color.fromARGB(255, 185, 62, 62),
      //           'green': Color.fromARGB(255, 69, 124, 63),
      //           'blue': Color.fromARGB(255, 110, 114, 146)
      //         }[args?['indicator']] ??
      //         const Color.fromARGB(255, 196, 233, 255)),
      //     textColor: Colors.black,
      //     fontSize: 16.0);
    }
  }
}
