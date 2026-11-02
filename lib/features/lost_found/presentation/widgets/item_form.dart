import 'package:flutter/material.dart';

import '../../domain/enums/item_status.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  ItemStatus? _status;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome do objeto',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
            ),
            minLines: 3,
            maxLines: 4,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Local',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),
          Text('Situação', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<ItemStatus>(
            segments: const [
              ButtonSegment(value: ItemStatus.lost, label: Text('Perdido')),
              ButtonSegment(value: ItemStatus.found, label: Text('Encontrado')),
            ],
            selected: _status == null ? const {} : {_status!},
            onSelectionChanged: (Set<ItemStatus> selected) {
              setState(() => _status = selected.first);
            },
            emptySelectionAllowed: true,
          ),
          const SizedBox(height: 32),
          FilledButton(onPressed: () {}, child: const Text('Salvar')),
        ],
      ),
    );
  }
}
