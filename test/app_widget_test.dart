import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:coma_bem/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Validação Funcional: O robô vai fazer Login e navegar até ao Cadastro', (WidgetTester tester) async {
    // 1. Abre a aplicação
    app.main();
    await tester.pumpAndSettle();

    // 2. Localiza os campos na LoginScreen
    final campoEmail = find.byType(TextField).first;
    final campoSenha = find.byType(TextField).last;
    final botaoEntrar = find.text('Entrar');

    // 3. Digita credenciais e clica no botão
    await tester.enterText(campoEmail, 'admin@comabem.com');
    await tester.enterText(campoSenha, 'senha123');
    await tester.pumpAndSettle();

    await tester.tap(botaoEntrar);
    await tester.pumpAndSettle();

    // 4. Valida a chegada ao Catálogo de Restaurantes
    expect(find.text('Catálogo de Restaurantes'), findsOneWidget);

    // 5. PASSO 5 (DESAFIO): Clica no botão (+) e valida a Tela de Cadastro
    final botaoNovo = find.byIcon(Icons.add);
    await tester.tap(botaoNovo);
    await tester.pumpAndSettle();

    expect(find.textContaining('Foto do Prato'), findsOneWidget);
  });
}