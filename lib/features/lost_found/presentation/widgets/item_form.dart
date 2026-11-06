import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/lost_found_item.dart';
import '../../domain/enums/item_status.dart';
import '../providers/create_item_provider.dart';

/// Formulário de cadastro (CARD-024, validação CARD-025, salvamento CARD-026).
///
/// O botão "Salvar" valida todos os campos antes de enviar; com dados
/// inválidos nenhuma gravação é disparada. Com dados válidos, chama
/// `CreateItemNotifier.submit` uma única vez a partir do gesto do usuário
/// (nunca a partir do `build`), que grava na nuvem via caso de uso.
///
/// Decisões da equipe registradas para o CARD-026:
/// - Durante a gravação os campos ficam desabilitados (`enabled: false` /
///   `IgnorePointer`), então nenhuma alteração é possível nesse período.
/// - O bloqueio visual (botão desabilitado + indicador) coexiste com o
///   bloqueio do estado (CARD-016: `submit` ignora chamadas com
///   `state.isLoading`), de modo que toques rápidos repetidos geram um
///   único registro mesmo antes da reconstrução da interface.
/// - Após o sucesso, a tela retorna (`pop`) para a listagem, que é
///   recarregada da nuvem pela invalidação feita no notifier (CARD-028).
///   Em caso de falha, permanece no formulário com os dados preservados
///   (mensagem e nova tentativa no CARD-027).
/// - Se o usuário sair da tela durante a gravação (voltar do sistema), a
///   gravação não é cancelada: o provider não é `autoDispose`, conclui a
///   escrita e invalida a listagem; a navegação de retorno só ocorre se o
///   formulário ainda estiver montado (`mounted`), sem inconsistência.
class ItemForm extends ConsumerStatefulWidget {
  const ItemForm({super.key});

  @override
  ConsumerState<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends ConsumerState<ItemForm> {
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

  Future<void> _handleSave() async {
    if (!_validate()) {
      return;
    }

    final item = LostFoundItem(
      // Id gerado pelo Firestore e data definida pelo servidor
      // (`FieldValue.serverTimestamp()`); valores aqui são ignorados.
      id: '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      status: _status!,
      createdAt: LostFoundItem.unknownCreatedAt,
    );

    await ref.read(createItemProvider.notifier).submit(item);

    if (!mounted) {
      return;
    }

    final submission = ref.read(createItemProvider);
    if (!submission.hasError) {
      Navigator.of(context).pop();
    }
    // Em caso de falha permanece no formulário com os dados preservados;
    // mensagem e nova tentativa pertencem ao CARD-027.
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(createItemProvider).isLoading;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              enabled: !isSubmitting,
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
              enabled: !isSubmitting,
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
              enabled: !isSubmitting,
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
            IgnorePointer(
              ignoring: isSubmitting,
              child: SegmentedButton<ItemStatus>(
                segments: const [
                  ButtonSegment(value: ItemStatus.lost, label: Text('Perdido')),
                  ButtonSegment(
                    value: ItemStatus.found,
                    label: Text('Encontrado'),
                  ),
                ],
                selected: _status == null ? const {} : {_status!},
                onSelectionChanged: (Set<ItemStatus> selected) {
                  if (isSubmitting) {
                    return;
                  }
                  setState(() {
                    _status = selected.first;
                    _statusError = null;
                  });
                },
                emptySelectionAllowed: true,
              ),
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
              onPressed: isSubmitting ? null : _handleSave,
              child: isSubmitting
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Salvando...'),
                      ],
                    )
                  : const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
