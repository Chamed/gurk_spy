import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhum usuário encontrado com este e-mail.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'E-mail inválido.';
      } else {
        errorMessage = 'Erro ao fazer login: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro desconhecido: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }
}