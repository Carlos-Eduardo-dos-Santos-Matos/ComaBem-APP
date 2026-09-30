import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../components/campo_formulario_customizado.dart';
import '../components/botao_customizado.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _fazerLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bem-vindo!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Campos e botão customizados
            CampoFormularioCustomizado(
              titulo: 'E-mail',
              controlador: _emailController,
              tipoTeclado: TextInputType.emailAddress,
            ),
            CampoFormularioCustomizado(
              titulo: 'Senha',
              controlador: _senhaController,
              ocultarTexto: true,
            ),
            const SizedBox(height: 15),

            BotaoCustomizado(
              texto: 'Entrar',
              onPressed: _fazerLogin,
            ),
          ],
        ),
      ),
    );
  }
}