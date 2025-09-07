import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Conecta con el talento de la frontera sur',
            style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(
          'Plataforma de empleo para jóvenes y empresas en Tapachula. '
          'Publica vacantes, postula y haz seguimiento en un mismo lugar.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/vacancies'),
              child: const Text('Buscar vacantes'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/company'),
              child: const Text('Publicar vacante'),
            ),
          ],
        ),
      ],
    );

    final imageCard = Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      clipBehavior: Clip.antiAlias,
      child: const Center(child: Icon(Icons.people_alt, size: 96)),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: textColumn),
                const SizedBox(width: 24),
                Expanded(child: imageCard),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textColumn,
                const SizedBox(height: 16),
                imageCard,
              ],
            ),
    );
  }
}
