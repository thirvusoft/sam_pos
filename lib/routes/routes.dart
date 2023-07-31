import 'package:get/get_navigation/src/routes/get_route.dart';

import '../Pages/home_page.dart';
import '../Pages/login_page.dart';
import '../Pages/qr_code.dart';

class Routes {
  static String homepage = '/homepage';
  static String loginpage = '/loginpage';
  static String qrcode = '/qrcode';
}

final getPages = [
  GetPage(
    name: Routes.loginpage,
    page: () => const LoginPage(),
  ),
  GetPage(
    name: Routes.homepage,
    page: () => const Homepage(),
  ),
  GetPage(
    name: Routes.qrcode,
    page: () => const Qrcode(),
  ),
];
