import 'package:flutter/material.dart';

class VacancyCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String salary;
  final VoidCallback? onTap;

  const VacancyCard({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$company • $location • $salary'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
