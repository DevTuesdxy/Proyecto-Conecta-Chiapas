import 'package:flutter/material.dart';
import '../widgets/vacancy_card.dart';

class VacancyListScreen extends StatelessWidget {
  const VacancyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vacantes')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 20,
        itemBuilder: (_, i) => VacancyCard(
          title: 'Backend FastAPI #$i',
          company: 'Empresa #$i',
          location: 'Tapachula',
          salary: '\$18,000 MXN',
          onTap: () => Navigator.pushNamed(context, '/vacancy'),
        ),
      ),
    );
  }
}
