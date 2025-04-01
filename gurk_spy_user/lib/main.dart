import 'package:flutter/material.dart';
import 'package:gurk_spy_user/views/login_view.dart';
import 'package:gurk_spy_user/views/register_view.dart';

void main() {
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
