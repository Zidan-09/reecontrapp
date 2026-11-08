import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/communication_failure.dart';
import '../../domain/entities/lost_found_item.dart';
import '../../domain/enums/item_status.dart';
import '../providers/create_item_provider.dart';

/// Formulário de cadastro (CARD-024 a CARD-027).
///
/// O botão valida todos os campos antes de enviar; com dados
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
///   e a mensagem do CARD-014; o botão principal permite tentar novamente.
/// - O retorno fica bloqueado durante o envio. Após uma falha é possível
///   sair e reabrir o formulário: o provider conserva a operação em memória.
/// - Após o primeiro envio os dados ficam bloqueados até o sucesso, evitando
///   transformar uma operação de resultado desconhecido em outro cadastro.
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

  static const _maxNameLength = 60;
  static const _maxDescriptionLength = 200;

  @override
  void initState() {
    super.initState();
    final pending = ref.read(createItemProvider.notifier).pendingItem;
    if (pending != null) {
      _nameController.text = pending.name;
      _descriptionController.text = pending.description;
      _locationController.text = pending.location;
      _status = pending.status;
    }
  }

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
    if (text.length > _maxNameLength) {
      return 'Nome deve ter até $_maxNameLength caracteres';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Informe a descrição';
    if (text.length > _maxDescriptionLength) {
      return 'Descrição deve ter até $_maxDescriptionLength caracteres';
    }
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
    if (ref.read(createItemProvider).isLoading || !_validate()) {
      return;
    }

    final item = LostFoundItem(
      // O provider atribui a identidade na primeira tentativa e a conserva.
      // A data é definida pelo servidor somente na criação inicial.
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
    if (!submission.isLoading && !submission.hasError) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final submission = ref.watch(createItemProvider);
    final isSubmitting = submission.isLoading;
    final hasPendingOperation =
        ref.read(createItemProvider.notifier).pendingItem != null;
    final fieldsLocked = isSubmitting || hasPendingOperation;
    final error = submission.error;
    final errorMessage = error == null
        ? const CommunicationFailure.unknown().userMessage
        : toCommunicationFailure(error).userMessage;

    return PopScope(
      canPop: !isSubmitting,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FormHeader(
                    title: hasPendingOperation
                        ? 'Conclua o cadastro pendente'
                        : 'Descreva o objeto',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4E4E4)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Sobre o objeto',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _nameController,
                            enabled: !fieldsLocked,
                            decoration: const InputDecoration(
                              labelText: 'Nome do objeto',
                              hintText: 'Ex.: Mochila preta',
                              helperText: 'Até $_maxNameLength caracteres',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.label_outlined),
                            ),
                            maxLength: _maxNameLength,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            validator: _validateName,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            enabled: !fieldsLocked,
                            decoration: const InputDecoration(
                              labelText: 'Descrição',
                              hintText:
                                  'Ex.: Com adesivos, vista perto da cantina',
                              helperText:
                                  'Até $_maxDescriptionLength caracteres',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.description_outlined),
                              alignLabelWithHint: true,
                            ),
                            minLines: 3,
                            maxLines: 4,
                            maxLength: _maxDescriptionLength,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            validator: _validateDescription,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Onde e como',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _locationController,
                            enabled: !fieldsLocked,
                            decoration: const InputDecoration(
                              labelText: 'Local',
                              hintText: 'Ex.: Biblioteca, bloco B',
                              helperText:
                                  'Onde o objeto foi perdido ou encontrado',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.place_outlined),
                            ),
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                            validator: _validateLocation,
                            onFieldSubmitted: (_) => _handleSave(),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Situação',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Escolha uma das opções abaixo.',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          IgnorePointer(
                            ignoring: fieldsLocked,
                            child: SegmentedButton<ItemStatus>(
                              emptySelectionAllowed: true,
                              segments: const [
                                ButtonSegment<ItemStatus>(
                                  value: ItemStatus.lost,
                                  label: Text('Perdido'),
                                  icon: Icon(Icons.search_outlined),
                                ),
                                ButtonSegment<ItemStatus>(
                                  value: ItemStatus.found,
                                  label: Text('Encontrado'),
                                  icon: Icon(Icons.check_circle_outlined),
                                ),
                              ],
                              selected: _status == null
                                  ? const <ItemStatus>{}
                                  : {_status!},
                              showSelectedIcon: false,
                              onSelectionChanged: fieldsLocked
                                  ? null
                                  : (selection) {
                                      setState(() {
                                        _status = selection.first;
                                        _statusError = null;
                                      });
                                    },
                            ),
                          ),
                          if (_statusError != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.error_outlined,
                                  size: 16,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _statusError!,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (hasPendingOperation && !isSubmitting) ...[
                            const SizedBox(height: 16),
                            _InfoBanner(
                              text:
                                  'Seus dados foram preservados. Tente novamente '
                                  'para concluir este cadastro antes de iniciar '
                                  'outro.',
                            ),
                          ],
                          if (submission.hasError && !isSubmitting) ...[
                            const SizedBox(height: 16),
                            Semantics(
                              liveRegion: true,
                              child: _ErrorBanner(message: errorMessage),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: isSubmitting ? null : _handleSave,
                    icon: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            hasPendingOperation
                                ? Icons.refresh_outlined
                                : Icons.check_outlined,
                          ),
                    label: Text(
                      isSubmitting
                          ? 'Salvando...'
                          : hasPendingOperation
                          ? 'Tentar novamente'
                          : 'Cadastrar objeto',
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      textStyle: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSubmitting
                        ? 'Salvando na nuvem. Aguarde sem sair da tela.'
                        : 'O registro aparece na lista assim que for salvo.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Título da tela com ícone.
class _FormHeader extends StatelessWidget {
  const _FormHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.add_box_outlined,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/// Aviso neutro para a operação pendente conservada em memória.
class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outlined,
            size: 20,
            color: colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSecondaryContainer,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Erro de envio com ícone e cor, sem detalhes técnicos.
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 20,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
