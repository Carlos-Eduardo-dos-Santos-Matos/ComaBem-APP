import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';
import '../components/campo_formulario_customizado.dart';
import '../components/botao_customizado.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _culinariaController = TextEditingController();
  final TextEditingController _pratoController = TextEditingController();
  final TextEditingController _rankingController = TextEditingController();
  final TextEditingController _recomendacoesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _foto;
  String _latitude = '';
  String _longitude = '';

  void _tirarFoto() async {
    final XFile? fotoCapturada = await _picker.pickImage(source: ImageSource.gallery);
    if (fotoCapturada != null) {
      setState(() {
        _foto = fotoCapturada;
      });
    }
  }

  Future<void> _pegarLocalizacao() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = posicao.latitude.toString();
        _longitude = posicao.longitude.toString();
      });
    }
  }

  void _salvarCadastro() async {
    if (_nomeController.text.trim().isEmpty || _culinariaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha os campos obrigatórios!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_rankingController.text.trim().isNotEmpty) {
      int? ranking = int.tryParse(_rankingController.text.trim());
      if (ranking == null || ranking < 1 || ranking > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('O Ranking deve ser uma nota de 1 a 5!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    try {
      Map<String, dynamic> dadosRestaurante = {
        'res_nm_restaurante': _nomeController.text.trim(),
        'res_ds_tipo_culinaria': _culinariaController.text.trim(),
        'res_nu_latitude': _latitude,
        'res_nu_longitude': _longitude,
      };

      await DatabaseHelper.instancia.inserirDados('restaurante', dadosRestaurante);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Restaurante cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (erro) {
      print('DEBUG - Erro ao salvar no SQLite: $erro');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro inesperado ao salvar.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _culinariaController.dispose();
    _pratoController.dispose();
    _rankingController.dispose();
    _recomendacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cadastro'),
        backgroundColor: const Color(0xFFFF4500),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CampoFormularioCustomizado(
              titulo: 'Nome do Restaurante',
              controlador: _nomeController,
            ),
            CampoFormularioCustomizado(
              titulo: 'Tipo de Culinária',
              controlador: _culinariaController,
            ),
            CampoFormularioCustomizado(
              titulo: 'Nome do Prato',
              controlador: _pratoController,
            ),
            CampoFormularioCustomizado(
              titulo: 'Ranking (1 a 5)',
              controlador: _rankingController,
              tipoTeclado: TextInputType.number,
            ),
            CampoFormularioCustomizado(
              titulo: 'Recomendações',
              controlador: _recomendacoesController,
            ),
            const SizedBox(height: 10),
            const Text(
              'Foto do Prato:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: _foto != null
                  ? Center(child: Text('Foto selecionada: ${_foto!.name}'))
                  : const Center(child: Text('Nenhuma foto selecionada')),
            ),
            const SizedBox(height: 10),
            BotaoCustomizado(
              texto: 'Carregar Foto do Prato',
              onPressed: _tirarFoto,
              icone: Icons.camera_alt,
            ),
            const SizedBox(height: 15),
            BotaoCustomizado(
              texto: 'Obter Localização',
              onPressed: _pegarLocalizacao,
              icone: Icons.my_location,
            ),
            const SizedBox(height: 5),
            Text(
              _latitude.isNotEmpty
                  ? 'Lat: $_latitude | Long: $_longitude'
                  : 'Coordenadas não obtidas',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            BotaoCustomizado(
              texto: 'Salvar Cadastro',
              onPressed: _salvarCadastro,
              corFundo: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}