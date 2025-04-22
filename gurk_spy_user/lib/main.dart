import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gurk_spy_user/views/home_view.dart';
import 'package:gurk_spy_user/views/login_view.dart';
import 'package:gurk_spy_user/views/register_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Seu Aplicativo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      initialRoute: '/login', 
      routes: {
        '/login': (context) => const LoginView(),     // TELA DE LOGIN
        '/signup': (context) => const SignUpView(),   // TELA DE CADASTRO
        '/home': (context) => HomeView(),    //TELA DE LISTAGEM DOS USUARIOS
      },
    );
  }
}