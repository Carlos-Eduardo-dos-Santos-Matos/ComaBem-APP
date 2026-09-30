import 'package:flutter_test/flutter_test.dart';

// Classe auxiliar de validação das regras de negócio do app
class ValidadorComaBem {
  static bool validarCamposObrigatorios(String nome, String culinaria) {
    return nome.trim().isNotEmpty && culinaria.trim().isNotEmpty;
  }

  static bool validarRanking(int nota) {
    return nota >= 1 && nota <= 5;
  }
}

void main() {
  group('Testes Unitários - Validações de Regra de Negócio (App Coma Bem)', () {
    
    // CT-04: Teste de nota de ranking válida
    test('Deve aprovar notas de ranking dentro do limite de 1 a 5', () {
      expect(ValidadorComaBem.validarRanking(1), isTrue);
      expect(ValidadorComaBem.validarRanking(3), isTrue);
      expect(ValidadorComaBem.validarRanking(5), isTrue);
    });

    // CT-04: Teste de nota de ranking inválida (Análise de Valor Limite)
    test('Deve rejeitar notas de ranking menores que 1 ou maiores que 5', () {
      expect(ValidadorComaBem.validarRanking(0), isFalse);
      expect(ValidadorComaBem.validarRanking(6), isFalse);
      expect(ValidadorComaBem.validarRanking(10), isFalse);
    });

    // CT: Teste de validação dos campos obrigatórios do cadastro
    test('Deve validar a obrigatoriedade dos campos nome e culinária', () {
      bool valido = ValidadorComaBem.validarCamposObrigatorios('Tokyo Garden', 'Japonês');
      bool invalidoSemNome = ValidadorComaBem.validarCamposObrigatorios('', 'Japonês');
      bool invalidoSemCulinaria = ValidadorComaBem.validarCamposObrigatorios('Tokyo Garden', '');

      expect(valido, isTrue);
      expect(invalidoSemNome, isFalse);
      expect(invalidoSemCulinaria, isFalse);
    });
  });

  group('Testes Unitários - Simulação de Estrutura de Dados do Banco', () {
    
    // CT-03: Teste de estrutura do mapa de inserção no banco
    test('Deve montar o Mapa do restaurante com todas as chaves corretas do banco', () {
      final dadosRestaurante = {
        'res_nm_restaurante': 'La Trattoria',
        'res_ds_tipo_culinaria': 'Italiano',
        'res_nu_latitude': '-23.5505',
        'res_nu_longitude': '-46.6333',
      };

      expect(dadosRestaurante.containsKey('res_nm_restaurante'), isTrue);
      expect(dadosRestaurante.containsKey('res_ds_tipo_culinaria'), isTrue);
      expect(dadosRestaurante['res_nm_restaurante'], equals('La Trattoria'));
    });
  });
}