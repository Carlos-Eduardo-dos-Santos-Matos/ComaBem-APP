import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Importa a aplicação principal com alias 'app'
import 'package:coma_bem/main.dart' as app;

void main() {
  // Inicializa o motor de testes de integração
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Validação Funcional: O robô vai fazer Login e navegar até ao Cadastro', (WidgetTester tester) async {
    // ----------------------------------------------------------------
    // PREPARAÇÃO: ABRINDO O APLICATIVO
    // ----------------------------------------------------------------
    app.main();
    await tester.pumpAndSettle();

    // ----------------------------------------------------------------
    // FASE 1: PROCURANDO ELEMENTOS NA TELA DE LOGIN
    // ----------------------------------------------------------------
    final campoEmail = find.byType(TextField).first;
    final campoSenha = find.byType(TextField).last;
    final botaoEntrar = find.text('Entrar');

    // ----------------------------------------------------------------
    // FASE 2: AÇÕES DO ROBÔ (DIGITANDO E CLICANDO)
    // ----------------------------------------------------------------
    await tester.enterText(campoEmail, 'admin@comabem.com');
    await tester.enterText(campoSenha, 'senha123');
    await tester.pumpAndSettle();

    await tester.tap(botaoEntrar);
    await tester.pumpAndSettle();

    // ----------------------------------------------------------------
    // FASE 3: AVALIAÇÃO DA TELA DE CATÁLOGO
    // ----------------------------------------------------------------
    expect(find.text('Catálogo de Restaurantes'), findsOneWidget);

    // ----------------------------------------------------------------
    // PASSO 5: DESAFIO FINAL (NAVEGAÇÃO PARA A TELA DE CADASTRO)
    // ----------------------------------------------------------------
  // 1. Encontra o botão flutuante (+)
    final botaoNovo = find.byIcon(Icons.add);

    // 2. Manda o robô clicar no botão
    await tester.tap(botaoNovo);

    // 3. Aguarda 2 segundos para a transição carregar (sem esperar pelo cursor de texto)
    await tester.pump(const Duration(seconds: 2));

    // 4. Valida se a tela de Novo Cadastro abriu verificando o texto
    expect(find.text('Foto do Prato:'), findsOneWidget);
  });
}