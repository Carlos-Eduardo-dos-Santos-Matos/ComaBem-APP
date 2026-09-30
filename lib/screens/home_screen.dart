import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'cadastro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _restaurantes = [];

  @override
  void initState() {
    super.initState();
    _carregarRestaurantes();
  }

  void _carregarRestaurantes() async {
    var dados = await DatabaseHelper.instancia.consultarDados('restaurante');
    if (!mounted) return;
    setState(() {
      _restaurantes = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Restaurantes'),
        backgroundColor: const Color(0xFFFF4500),
      ),
      body: ListView.builder(
        itemCount: _restaurantes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            color: Colors.orange[50],
            child: ListTile(
              leading: const Icon(Icons.fastfood, color: Color(0xFFFF4500)),
              title: Text(_restaurantes[index]['res_nm_restaurante'] ?? ''),
              subtitle: Text(
                'Culinária: ${_restaurantes[index]['res_ds_tipo_culinaria'] ?? ''}',
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroScreen()),
          );
          _carregarRestaurantes(); // Recarrega a lista ao voltar da tela de cadastro
        },
        backgroundColor: const Color(0xFFFF4500),
        child: const Icon(Icons.add),
      ),
    );
  }
}