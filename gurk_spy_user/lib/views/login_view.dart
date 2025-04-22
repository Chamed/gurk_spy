import 'package:flutter/material.dart';
import 'package:gurk_spy_user/views/register_view.dart';
import 'package:gurk_spy_user/controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _loginController = LoginController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    
    final user = await _loginController.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
      context,
    );

    setState(() => _isLoading = false);

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título GURK - SPY
          const Center(
            child: Text(
              'GURK - SPY',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          
          
          Icon(
            Icons.visibility_outlined , // Ícone de monitoramento cardíaco
            size: 100,
            color: const Color(0xFF673AB7),
          ),
          
          const SizedBox(height: 24.0),
          const Center(
            child: Text(
              'Bem-vindo de volta!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          
          _buildTextField(_emailController, 'E-mail'),
          const SizedBox(height: 12.0),
          _buildTextField(_passwordController, 'Senha', obscureText: true),
          const SizedBox(height: 8.0),
          
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Esqueceu a senha?',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
          
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF673AB7),
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Text(
                    'Entrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Não possui conta? '),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpView()),
                  );
                },
                child: const Text(
                  'Registre-se',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: obscureText,
      keyboardType: label == 'E-mail' ? TextInputType.emailAddress : null,
    );
  }
}