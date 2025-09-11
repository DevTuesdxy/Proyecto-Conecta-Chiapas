import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:conecta_chiapas/screens/detalle_vacante.dart';

void main() {
  testWidgets('VacancyDetailScreen muestra título y permite postularse',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: VacancyDetailScreen()),
    );

    // Verifica que aparece el título
    expect(find.text('Desarrollador Flutter Jr'), findsOneWidget);

    // Simula tap en el botón
    await tester.tap(find.text('Postularse'));
    await tester.pump();

    // Verifica que se mostró el SnackBar
    expect(find.text('Postulación enviada (demo)'), findsOneWidget);
  });
}
