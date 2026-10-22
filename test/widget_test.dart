import 'package:flutter_test/flutter_test.dart';
import 'package:rota_segura/main.dart'; // Verifique se o nome do pacote está correto

void main() {
  testWidgets('Verifica se o app carrega', (WidgetTester tester) async {
    // Tenta carregar o app
    await tester.pumpWidget(const RotaSeguraApp());

    // Verifica se o título aparece na tela
    expect(find.text('Rota Segura - Direção'), findsOneWidget);
  });
}