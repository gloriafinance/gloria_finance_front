import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/general.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:provider/provider.dart';

import '../../models/recurring_payment_competence_model.dart';
import '../../service/recurring_payment_execution_service.dart';
import '../../store/recurring_payment_execution_store.dart';
import '../../store/recurring_payment_monthly_store.dart';
import 'widgets/recurring_payment_amount_method_step.dart';
import 'widgets/recurring_payment_boleto_camera_step.dart';
import 'widgets/recurring_payment_boleto_entry_step.dart';
import 'widgets/recurring_payment_boleto_line_step.dart';
import 'widgets/recurring_payment_confirmation_step.dart';
import 'widgets/recurring_payment_execution_result_step.dart';
import 'widgets/recurring_payment_manual_registration_step.dart';
import 'widgets/recurring_payment_pix_key_step.dart';

/// Passos do fluxo de execução de uma competência.
enum RecurringPaymentExecutionStep {
  amountAndMethod,
  pixKey,
  pixConfirmation,
  boletoEntry,
  boletoLine,
  boletoCamera,
  boletoConfirmation,
  result,
}

/// Abre o fluxo de execução de uma competência.
///
/// Com banca conectada o caminho vem da matriz (valor fixo/variável × destino
/// PIX salvo ou não); sem banca, é sempre o registro manual.
Future<void> openRecurringPaymentExecution(
  BuildContext context, {
  required RecurringPaymentCompetenceModel item,
}) {
  final session = context.read<AuthSessionStore>().state.session;

  if (isMobile(context)) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => RecurringPaymentExecutionSheet(
            item: item,
            hasBanking: session.asaasConnect,
            symbolFormatMoney: session.symbolFormatMoney,
          ),
    );
  }

  return showDialog<void>(
    context: context,
    builder:
        (_) => Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: RecurringPaymentExecutionSheet(
              item: item,
              hasBanking: session.asaasConnect,
              symbolFormatMoney: session.symbolFormatMoney,
            ),
          ),
        ),
  );
}

class RecurringPaymentExecutionSheet extends StatefulWidget {
  const RecurringPaymentExecutionSheet({
    super.key,
    required this.item,
    required this.hasBanking,
    required this.symbolFormatMoney,
    this.service,
  });

  final RecurringPaymentCompetenceModel item;
  final bool hasBanking;
  final String symbolFormatMoney;
  final RecurringPaymentExecutionService? service;

  @override
  State<RecurringPaymentExecutionSheet> createState() =>
      RecurringPaymentExecutionSheetState();
}

class RecurringPaymentExecutionSheetState
    extends State<RecurringPaymentExecutionSheet> {
  late final RecurringPaymentExecutionStore _store =
      RecurringPaymentExecutionStore(
        item: widget.item,
        hasBanking: widget.hasBanking,
        service: widget.service,
      );

  late RecurringPaymentExecutionStep _step = _initialStep();

  RecurringPaymentExecutionStep _initialStep() {
    if (!widget.hasBanking) {
      return RecurringPaymentExecutionStep.amountAndMethod;
    }

    // Fixo com destino guardado não tem nada a decidir: vai direto à confirmação.
    final hasDestination = widget.item.recurringPayment.hasPixDestination;
    if (widget.item.recurringPayment.isFixed && hasDestination) {
      return RecurringPaymentExecutionStep.pixConfirmation;
    }

    return RecurringPaymentExecutionStep.amountAndMethod;
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final item = widget.item;

    return ChangeNotifierProvider<RecurringPaymentExecutionStore>.value(
      value: _store,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_canGoBack) ...[
                    IconButton(
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back, size: 20),
                      color: AppColors.grey,
                      tooltip: l10n.recurringPaymentsExecution_common_back,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title(l10n),
                          style: const TextStyle(
                            fontFamily: AppFonts.fontTitle,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item.recurringPayment.name} · '
                          '${item.month.slashLabel}',
                          style: const TextStyle(
                            fontFamily: AppFonts.fontText,
                            fontSize: 13.5,
                            color: Color(0xFF5F5F5F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                    color: AppColors.grey,
                    tooltip: l10n.recurringPaymentsExecution_common_close,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _content(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    switch (_step) {
      case RecurringPaymentExecutionStep.amountAndMethod:
        if (!widget.hasBanking) {
          return RecurringPaymentManualRegistrationStep(
            symbolFormatMoney: widget.symbolFormatMoney,
            onSubmit: _submitManual,
          );
        }
        return RecurringPaymentAmountMethodStep(
          symbolFormatMoney: widget.symbolFormatMoney,
          onContinue: _continueFromAmountAndMethod,
        );
      case RecurringPaymentExecutionStep.pixKey:
        return RecurringPaymentPixKeyStep(
          onContinue:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.pixConfirmation,
              ),
        );
      case RecurringPaymentExecutionStep.pixConfirmation:
        return RecurringPaymentConfirmationStep(
          symbolFormatMoney: widget.symbolFormatMoney,
          onConfirm: () => _submitBanking(),
        );
      case RecurringPaymentExecutionStep.boletoEntry:
        return RecurringPaymentBoletoEntryStep(
          onCamera:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.boletoCamera,
              ),
          onType:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.boletoLine,
              ),
        );
      case RecurringPaymentExecutionStep.boletoLine:
        return RecurringPaymentBoletoLineStep(onValidate: _simulateTypedBill);
      case RecurringPaymentExecutionStep.boletoCamera:
        return RecurringPaymentBoletoCameraStep(
          onDetected: _simulateScannedBill,
          onTypeManually:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.boletoLine,
              ),
        );
      case RecurringPaymentExecutionStep.boletoConfirmation:
        return RecurringPaymentConfirmationStep(
          symbolFormatMoney: widget.symbolFormatMoney,
          onConfirm: () => _submitBanking(),
          onEditBoleto:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.boletoLine,
              ),
        );
      case RecurringPaymentExecutionStep.result:
        return RecurringPaymentExecutionResultStep(
          result: _store.state.result!,
          method: _store.state.method,
          symbolFormatMoney: widget.symbolFormatMoney,
          onClose: () => Navigator.of(context).pop(),
          onRetry:
              () => setState(() {
                _store.setMethod(_store.state.method);
                _step = _initialStep();
              }),
        );
    }
  }

  void _continueFromAmountAndMethod() {
    if (_store.state.isPix) {
      setState(() {
        _step =
            _store.state.requiresPixKey
                ? RecurringPaymentExecutionStep.pixKey
                : RecurringPaymentExecutionStep.pixConfirmation;
      });
      return;
    }

    setState(() => _step = RecurringPaymentExecutionStep.boletoEntry);
  }

  Future<bool> _simulateScannedBill(String barcode) async {
    final success = await _store.simulateBill(
      RecurringPaymentBillSimulationInput.barCode(barcode),
      sourceValue: barcode,
    );
    if (success && mounted) {
      setState(() => _step = RecurringPaymentExecutionStep.boletoConfirmation);
    }
    return success;
  }

  Future<void> _simulateTypedBill() async {
    final digits = _store.state.boletoLine;
    final input =
        digits.length == 44
            ? RecurringPaymentBillSimulationInput.barCode(digits)
            : RecurringPaymentBillSimulationInput.identificationField(digits);
    final success = await _store.simulateBill(input, sourceValue: digits);
    if (success && mounted) {
      setState(() => _step = RecurringPaymentExecutionStep.boletoConfirmation);
    }
  }

  Future<void> _submitBanking() async {
    final result = await _store.submit();
    if (!mounted) return;

    if (result == null) {
      Toast.showMessage(
        context.l10n.recurringPaymentsExecution_error_pay,
        ToastType.error,
      );
      return;
    }

    // O mês mudou de estado: recarrega para a lista refletir o banco.
    context.read<RecurringPaymentMonthlyStore>().load(force: true);
    setState(() => _step = RecurringPaymentExecutionStep.result);
  }

  Future<void> _submitManual({
    required String paymentDate,
    required String availabilityAccountId,
    required MultipartFile voucher,
  }) async {
    final success = await _store.submitManual(
      paymentDate: paymentDate,
      availabilityAccountId: availabilityAccountId,
      voucher: voucher,
    );
    if (!mounted) return;

    if (!success) {
      Toast.showMessage(
        context.l10n.recurringPaymentsExecution_error_register,
        ToastType.error,
      );
      return;
    }

    Toast.showMessage(
      context.l10n.recurringPaymentsExecution_manual_success,
      ToastType.success,
    );
    context.read<RecurringPaymentMonthlyStore>().load(force: true);
    Navigator.of(context).pop();
  }

  String _title(AppLocalizations l10n) {
    if (!widget.hasBanking) {
      return l10n.recurringPaymentsExecution_manual_title;
    }

    switch (_step) {
      case RecurringPaymentExecutionStep.amountAndMethod:
        return l10n.recurringPaymentsExecution_method_title;
      case RecurringPaymentExecutionStep.pixKey:
        return l10n.recurringPaymentsExecution_pix_key_step_title;
      case RecurringPaymentExecutionStep.pixConfirmation:
        return l10n.recurringPaymentsExecution_pix_confirm_title;
      case RecurringPaymentExecutionStep.boletoEntry:
        return l10n.recurringPaymentsExecution_boleto_entry_title;
      case RecurringPaymentExecutionStep.boletoLine:
        return l10n.recurringPaymentsExecution_boleto_line_step_title;
      case RecurringPaymentExecutionStep.boletoCamera:
        return l10n.recurringPaymentsExecution_boleto_scan_title;
      case RecurringPaymentExecutionStep.boletoConfirmation:
        return l10n.recurringPaymentsExecution_boleto_confirm_title;
      case RecurringPaymentExecutionStep.result:
        return l10n.recurringPaymentsExecution_sent_title;
    }
  }

  bool get _canGoBack =>
      _step != RecurringPaymentExecutionStep.result &&
      (_step != _initialStep() ||
          _step == RecurringPaymentExecutionStep.pixConfirmation);

  void _goBack() {
    if (_step == _initialStep() &&
        _step != RecurringPaymentExecutionStep.pixConfirmation) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _step = switch (_step) {
        RecurringPaymentExecutionStep.pixKey ||
        RecurringPaymentExecutionStep
            .boletoEntry => RecurringPaymentExecutionStep.amountAndMethod,
        RecurringPaymentExecutionStep.pixConfirmation =>
          _store.state.requiresPixKey
              ? RecurringPaymentExecutionStep.pixKey
              : RecurringPaymentExecutionStep.amountAndMethod,
        RecurringPaymentExecutionStep.boletoLine ||
        RecurringPaymentExecutionStep
            .boletoCamera => RecurringPaymentExecutionStep.boletoEntry,
        RecurringPaymentExecutionStep.boletoConfirmation =>
          RecurringPaymentExecutionStep.boletoLine,
        RecurringPaymentExecutionStep.amountAndMethod ||
        RecurringPaymentExecutionStep
            .result => RecurringPaymentExecutionStep.amountAndMethod,
      };
    });
  }
}
