import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'), 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F4F6), // Cor de fundo
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.person_add,
              size: 80,
              color: Colors.black,
            ),
            const SizedBox(height: 16.0),
            const Center(
              child: Text(
                'Crie sua conta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24.0),
            _buildTextField('Nome de usuário'),
            const SizedBox(height: 12.0),
            _buildTextField('E-mail'),
            const SizedBox(height: 12.0),
            _buildTextField('Senha', obscureText: true),
            const SizedBox(height: 12.0),
            _buildTextField('Digite a senha novamente', obscureText: true),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Implementar lógica de cadastro
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              child: const Text(
                'Cadastrar-se',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool obscureText = false}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: obscureText,
    );
  }
}
