import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../routes/routes.dart';
import '../widgets/snackbar.dart';

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
    if (apiHeaders.isEmpty) {
      apiHeaders = {'Content-Type': 'application/json'};
    }

    var request = http.Request(
      'GET',
      Uri.parse("""${dotenv.env['API_URL']}/api/method/$method"""),
    );

    request.body = json.encode(args);

    request.headers.addAll(apiHeaders);
    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    callback?.call(response, res);
    if ((res?['session_expired'] == 1 ||
        !response.headers.toString().contains("system_user=yes"))) {
      Get.toNamed("/loginpage");
      showCustomSnackBar(
        "Session expired",
        title: "Failure",
        icon: false,
        iconColor: Colors.white,
        backgroundColor: Colors.red.shade700,
      );
    }
  }
}
