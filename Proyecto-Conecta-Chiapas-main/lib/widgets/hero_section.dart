import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.center, // centra el bloque interno
      children: [
        Wrap(
          alignment: WrapAlignment.center, // botones centrados
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: const Text('Profesionales'),
            ),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/company'),
              child: const Text('Empresas'),
            ),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: const Text('Capacitacion'),
            ),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/vacancies'),
              child: const Text('Empleos'),
            ),
          ],
        ),
        const SizedBox(height: 150),
        Text.rich(
          TextSpan(
            text: 'Conecta con el talento de\n',
            style: textTheme.headlineLarge?.copyWith(
              color: const Color(0xFF000000),
              height: 1.05, // líneas más pegadas
            ),
            children: [
              TextSpan(
                text: 'Chiapas',
                style: textTheme.headlineLarge?.copyWith(
                  color: const Color(0xFF00A950), // #00A950
                  height: 1.05,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'La primera red profesional de Chiapas donde el talento local encuentra '
          'oportunidades para crecer y desarrollarse.',
          style: textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 200),
      ],
    );

    final imageCard = Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Icon(
          Icons.people_alt,
          size: 96,
          color: scheme.onSurface,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.start, // centra el contenido del Row
              children: [
                // Centra el bloque de texto dentro del ancho disponible
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: textColumn,
                  ),
                ),
                const SizedBox(width: 24),
                // Centra también la tarjeta de imagen
                /*  Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: imageCard,
                  ),
                ), */
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start, // centrado en móvil
              children: [
                textColumn,
                const SizedBox(height: 16),
                imageCard,
              ],
            ),
    );
  }
}
