import 'package:flutter/material.dart';

class CompanyDashboard extends StatelessWidget {
  const CompanyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel: Empresa')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const _NewVacancyDialog(),
        ),
        label: const Text('Publicar vacante'),
        icon: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, i) => ListTile(
          title: Text('Vacante publicada #$i'),
          subtitle: const Text('Estado: Activa • 23 postulaciones'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ),
    );
  }
}

class _NewVacancyDialog extends StatefulWidget {
  const _NewVacancyDialog();

  @override
  State<_NewVacancyDialog> createState() => _NewVacancyDialogState();
}

class _NewVacancyDialogState extends State<_NewVacancyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _salary = TextEditingController();
  final _location = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _salary.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva vacante'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _salary,
                decoration: const InputDecoration(labelText: 'Salario'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _location,
                decoration: const InputDecoration(labelText: 'Ubicación'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vacante publicada (demo)')),
              );
            }
          },
          child: const Text('Publicar'),
        ),
      ],
    );
  }
}
