import 'package:flutter/material.dart';
import 'package:flutter_health/app/view/HomePage.dart';
import 'package:flutter_health/app/view/LoginPage.dart';
import 'package:flutter_health/app/view/RegisterPage.dart';
import 'package:flutter_health/app/view/ServiceInspect.dart';
import 'package:flutter_health/app/view/ServicePage.dart';
import 'package:flutter_health/app/view/Snap.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'theme.dart';
import 'package:localstorage/localstorage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalStorage storage = LocalStorage('personal_data');
  late Future<bool> _isLoggedFuture;

  @override
  void initState() {
    super.initState();
    _isLoggedFuture = checkUserLoggedIn();
  }

  Future<bool> checkUserLoggedIn() async {
    await storage.ready;
    var username = await storage.getItem('username');
    return username != null && username.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      initialRoute: '/snap',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/snap', page: () => SnapImage()),
        GetPage(name: '/service', page: () => const ServicePage()),
        GetPage(name: '/service/:id', page: () => const ServiceView()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
      ],
    );
  }
}
