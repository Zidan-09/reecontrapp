import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/errors/communication_failure.dart';
import '../../domain/entities/lost_found_item.dart';
import '../../domain/enums/item_status.dart';
import '../providers/create_item_provider.dart';

/// Formulário de cadastro (CARD-024 a CARD-027).
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
///   e a mensagem do CARD-014; o botão Salvar permite tentar novamente.
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
    final submission = ref.watch(createItemProvider);
    final isSubmitting = submission.isLoading;
    final hasPendingOperation =
        ref.read(createItemProvider.notifier).pendingItem != null;
    final fieldsLocked = isSubmitting || hasPendingOperation;
    final error = submission.error;
    final errorMessage = error == null
        ? const CommunicationFailure.unknown().userMessage
        : toCommunicationFailure(error).userMessage;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return PopScope(
      canPop: !isSubmitting,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Situação ──────────────────────────────────
              Text(
                'Situação do objeto',
                style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 10),
              IgnorePointer(
                ignoring: fieldsLocked,
                child: Row(
                  children: [
                    Expanded(
                      child: _StatusCard(
                        icon: Icons.search_rounded,
                        label: 'Perdi algo',
                        sublabel: 'O objeto sumiu',
                        selected: _status == ItemStatus.lost,
                        selectedColor: AppTheme.lost,
                        selectedBg: AppTheme.lostBg(context),
                        onTap: () => setState(() {
                          _status = ItemStatus.lost;
                          _statusError = null;
                        }),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatusCard(
                        icon: Icons.front_hand_rounded,
                        label: 'Encontrei algo',
                        sublabel: 'Achei um objeto',
                        selected: _status == ItemStatus.found,
                        selectedColor: AppTheme.found,
                        selectedBg: AppTheme.foundBg(context),
                        onTap: () => setState(() {
                          _status = ItemStatus.found;
                          _statusError = null;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              if (_statusError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _statusError!,
                  style: TextStyle(color: cs.error, fontSize: 12),
                ),
              ],
              const SizedBox(height: 24),

              // ── Campos ────────────────────────────────────
              _FieldLabel('Nome do objeto'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                enabled: !fieldsLocked,
                decoration: const InputDecoration(
                  hintText: 'Ex: Garrafa, Mochila, Carteira…',
                  prefixIcon: Icon(Icons.label_outline_rounded),
                ),
                textInputAction: TextInputAction.next,
                validator: _validateName,
              ),
              const SizedBox(height: 16),

              _FieldLabel('Local'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                enabled: !fieldsLocked,
                decoration: const InputDecoration(
                  hintText: 'Ex: Sala 204, Biblioteca…',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                textInputAction: TextInputAction.next,
                validator: _validateLocation,
              ),
              const SizedBox(height: 16),

              _FieldLabel('Descrição'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                enabled: !fieldsLocked,
                decoration: const InputDecoration(
                  hintText: 'Detalhes que ajudem a identificar…',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.notes_rounded),
                  ),
                  alignLabelWithHint: true,
                ),
                minLines: 3,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                validator: _validateDescription,
              ),
              const SizedBox(height: 28),

              // ── Avisos ────────────────────────────────────
              if (hasPendingOperation && !isSubmitting) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: cs.onSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Seus dados foram preservados. '
                          'Tente novamente para concluir '
                          'este cadastro antes de iniciar outro.',
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (submission.hasError && !isSubmitting) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Semantics(
                    liveRegion: true,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 16,
                          color: cs.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Botão ─────────────────────────────────────
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
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Salvando...'),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hasPendingOperation
                                ? Icons.refresh_rounded
                                : Icons.send_rounded,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            hasPendingOperation
                                ? 'Tentar novamente'
                                : 'Registrar objeto',
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                'Os dados ficam visíveis para todos os usuários.',
                textAlign: TextAlign.center,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge
          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.selectedColor,
    required this.selectedBg,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String sublabel;
  final bool selected;
  final Color selectedColor;
  final Color selectedBg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? selectedBg : cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? selectedColor : cs.outlineVariant,
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? selectedColor : selectedBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : selectedColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? selectedColor : cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 11,
                color: selected
                    ? selectedColor.withValues(alpha: 0.75)
                    : cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 18,
              child: AnimatedOpacity(
                opacity: selected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
