import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerUser(
    String nome, 
    String email, 
    String senha, 
    BuildContext context,
  ) async {
    
    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.orange,
        ),
      );
      return null;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'nome': nome.trim(),
          'email': email.trim(),
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'A senha é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Este e-mail já está cadastrado.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'E-mail inválido.';
      } else {
        errorMessage = 'Erro ao cadastrar: ${e.message}';
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