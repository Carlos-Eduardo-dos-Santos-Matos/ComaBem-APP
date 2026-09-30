import 'models/cliente.dart';
import 'models/restaurante.dart';
import 'models/avaliacao.dart';

void main() {
  print('=== TESTE DE CONTROLE DE FLUXO (ATIVIDADE 7) ===\n');

  // 1. Testando Validação de Senha
  var usu = Cliente(1, 'Carlos', 'carlos@email.com', '123456');
  print('Testando senha curta (123):');
  usu.senha = '123';
  print('Testando senha correta (654321):');
  usu.senha = '654321';

  print('\n----------------------------------------\n');

  // 2. Testando Validação de Ranking
  var avl = Avaliacao(1, 5, 'Excelente!', 1, 1);
  print('Testando nota 10:');
  avl.ranking = 10;

  print('\n----------------------------------------\n');

  // 3. Testando Lista e Switch/Case com for-in
  List<Restaurante> listaDeRestaurantes = [
    Restaurante(1, 'Sushi House', '-23.5', '-46.6', 'Japonesa'),
    Restaurante(2, 'Cantina Bella', '-23.6', '-46.7', 'Italiana'),
    Restaurante(3, 'Boi Bom', '-23.7', '-46.8', 'Brasileira'),
  ];

  print('--- CATÁLOGO DE RESTAURANTES ---');
  for (Restaurante res in listaDeRestaurantes) {
    print('Nome: ${res.nomeRestaurante} | Tipo: ${res.tipoCulinaria}');
    res.exibirCategoriaCulinaria();
    print('----------------------------------------');
  }
}