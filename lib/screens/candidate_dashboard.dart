import 'package:flutter/material.dart';
import '../widgets/vacancy_card.dart';

class CandidateDashboard extends StatelessWidget {
  const CandidateDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel: Candidato')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (_, i) => VacancyCard(
          title: 'Desarrollador Flutter Jr. #$i',
          company: 'PYLP Panter y La People S.A. de C.V.',
          location: 'Tapachula, Chiapas',
          salary: '\$12,000 - \$16,000 MXN',
          onTap: () => Navigator.pushNamed(context, '/vacancy'),
        ),
      ),
    );
  }
}
