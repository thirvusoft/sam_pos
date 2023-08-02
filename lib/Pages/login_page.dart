import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/serialnocontroller.dart';
import '../modules/serviceapi.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/header.dart';
import '../widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //
  final _loginFormKey = GlobalKey<FormState>();
  final Serialno serialno_ = Get.put(Serialno());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController passwordController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            SizedBox(
                width: double.infinity,
                height: size.height * 0.3,
                child: Image.asset('assests/background.jpg')),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        const PageHeading(
                          title: 'Log-in',
                        ),
                        CustomInputField(
                            controller: emailController,
                            labelText: 'Email',
                            hintText: 'Your email id',
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Email is required!';
                              }
                              // if (!EmailValidator.validate(textValue)) {
                              //   return 'Please enter a valid email';
                              // }
                              return null;
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomInputField(
                          controller: passwordController,
                          labelText: 'Password',
                          hintText: 'Your password',
                          obscureText: true,
                          suffixIcon: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Password is required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: size.width * 0.80,
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => {},
                            child: const Text(
                              'Forget password?',
                              style: TextStyle(
                                color: Color(0xff939393),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomFormButton(
                            innerText: 'Login',
                            onPressed: () {
                              _handleLoginUser(emailController.text,
                                  passwordController.text);
                            }),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          width: size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account ? ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff939393),
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () => {},
                                child: const Text(
                                  'Sign-up',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xff748288),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _handleLoginUser(email, pwd) async {
    if (_loginFormKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // frappe.call(
      //     method: "login",
      //     args: {"usr": email, "pwd": pwd},
      //     callback: (response, result) async {
      //       if (response!.statusCode == 200) {
      //         print(response.statusCode);
      //         response.headers['cookie'] =
      //             "${response.headers['set-cookie'].toString()};";
      //         response.headers.removeWhere((key, value) =>
      //             ["set-cookie", 'content-length'].contains(key));
      //         apiHeaders = response.headers;
      //         await prefs.setString('request-header',
      //             json.encode(response.headers)); // store headers for API calls

      frappe.call(
          // context: context,
          method: "login",
          args: {"usr": email, "pwd": pwd},
          callback: (response, result) async {
            if (response!.statusCode == 200) {
              print(response.statusCode);
              response.headers['cookie'] =
                  "${response.headers['set-cookie'].toString()};";
              response.headers.removeWhere((key, value) =>
                  ["set-cookie", 'content-length'].contains(key));
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
  // await serialno_.salesInvoice(email, pwd);
}
