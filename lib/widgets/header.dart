import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const _Logo(),
          const SizedBox(width: 12),
          Text('Conecta Chiapas', style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text('Iniciar sesión'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text('Crear cuenta'),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Colors.teal.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.work_outline),
    );
  }
}
