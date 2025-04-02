import 'package:flutter/material.dart';
import 'package:gurk_spy_user/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gurk_spy_user/views/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
