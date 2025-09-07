import 'package:flutter/material.dart';

class VacancyDetailScreen extends StatelessWidget {
  const VacancyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de vacante')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Desarrollador Flutter Jr',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
                'PYLP Panter y La People S.A. de C.V. • Tapachula, Chiapas'),
            const SizedBox(height: 16),
            const Text(
              '''Descripción:
Buscamos desarrollador Jr con conocimientos en Flutter.''',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Postulación enviada (demo)')),
                );
              },
              child: const Text('Postularse'),
            ),
          ],
        ),
      ),
    );
  }
}
