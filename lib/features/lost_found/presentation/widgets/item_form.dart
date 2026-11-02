import 'package:flutter/material.dart';

import '../../domain/enums/item_status.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  ItemStatus? _status;
  String? _statusError;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Informe o nome do objeto';
    if (text.length > 60) return 'Nome deve ter até 60 caracteres';
    return null;
  }

  String? _validateDescription(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Informe a descrição';
    if (text.length > 200) return 'Descrição deve ter até 200 caracteres';
    return null;
  }

  String? _validateLocation(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Informe o local';
    return null;
  }

  bool _validate() {
    final formOk = _formKey.currentState!.validate();
    final statusOk = _status != null;
    setState(() => _statusError = statusOk ? null : 'Selecione a situação');
    return formOk && statusOk;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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
              validator: _validateName,
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
              validator: _validateDescription,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Local',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              validator: _validateLocation,
            ),
            const SizedBox(height: 24),
            Text('Situação', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<ItemStatus>(
              segments: const [
                ButtonSegment(value: ItemStatus.lost, label: Text('Perdido')),
                ButtonSegment(
                  value: ItemStatus.found,
                  label: Text('Encontrado'),
                ),
              ],
              selected: _status == null ? const {} : {_status!},
              onSelectionChanged: (Set<ItemStatus> selected) {
                setState(() {
                  _status = selected.first;
                  _statusError = null;
                });
              },
              emptySelectionAllowed: true,
            ),
            if (_statusError != null) ...[
              const SizedBox(height: 8),
              Text(
                _statusError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                if (_validate()) {}
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
