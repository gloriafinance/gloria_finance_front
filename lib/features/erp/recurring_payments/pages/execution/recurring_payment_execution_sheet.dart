import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/settings/banks/store/bank_store.dart';
import 'package:provider/provider.dart';

import '../../models/recurring_payment_competence_model.dart';
import '../../models/recurring_payment_execution_model.dart';
import '../../models/recurring_payment_source_ui_model.dart';
import '../../store/recurring_payment_execution_store.dart';
import '../../store/recurring_payment_monthly_store.dart';
import '../../../settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'widgets/recurring_payment_instrument_step.dart';
import 'widgets/recurring_payment_local_preview_step.dart';
import 'widgets/recurring_payment_pix_qr_amount_step.dart';
import 'widgets/recurring_payment_pix_qr_camera_step.dart';
import 'widgets/recurring_payment_pix_qr_entry_step.dart';
import 'widgets/recurring_payment_pix_qr_paste_step.dart';
import 'widgets/recurring_payment_source_step.dart';
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
  paymentSource,
  manualRegistration,
  asaasMethod,
  amountAndMethod,
  pixKey,
  pixConfirmation,
  boletoEntry,
  boletoLine,
  boletoCamera,
  boletoValidating,
  boletoConfirmation,
  pixQrEntry,
  pixQrCamera,
  pixQrPaste,
  pixQrAmount,
  pixQrPreview,
  localResult,
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

  return showDialog<void>(
    context: context,
    builder:
        (_) => RecurringPaymentExecutionSheet(
          item: item,
          asaasAvailable: session.asaasConnect,
          symbolFormatMoney: session.symbolFormatMoney,
        ),
  );
}

class RecurringPaymentExecutionSheet extends StatefulWidget {
  const RecurringPaymentExecutionSheet({
    super.key,
    required this.item,
    required this.asaasAvailable,
    required this.symbolFormatMoney,
    this.onManualRegister,
  });

  final RecurringPaymentCompetenceModel item;
  final bool asaasAvailable;
  final String symbolFormatMoney;
  final Future<bool> Function({
    required String paymentDate,
    required String availabilityAccountId,
    required MultipartFile? voucher,
  })?
  onManualRegister;

  @override
  State<RecurringPaymentExecutionSheet> createState() =>
      RecurringPaymentExecutionSheetState();
}

class RecurringPaymentExecutionSheetState
    extends State<RecurringPaymentExecutionSheet> {
  late final RecurringPaymentExecutionStore _store =
      RecurringPaymentExecutionStore(
        item: widget.item,
        asaasAvailable: widget.asaasAvailable,
      );

  RecurringPaymentExecutionStep _step =
      RecurringPaymentExecutionStep.paymentSource;
  RecurringPaymentSourceUiModel? _selectedSource;
  double? _qrAmount;
  String _qrAmountText = '';

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final item = widget.item;

    return ModalPage(
      title: '',
      width: 560,
      borderRadius: 22,
      contentPadding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
      header: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_step != RecurringPaymentExecutionStep.paymentSource)
            IconButton(
              onPressed: _goBack,
              icon: const Icon(Icons.arrow_back, size: 18),
              color: AppColors.grey,
              tooltip: l10n.recurringPaymentsExecution_common_back,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title(l10n),
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.recurringPayment.name} · ${item.month.slashLabel}',
                  style: const TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 12.5,
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
      body: ChangeNotifierProvider<RecurringPaymentExecutionStore>.value(
        value: _store,
        child: _content(context),
      ),
    );
  }

  Widget _content(BuildContext context) {
    switch (_step) {
      case RecurringPaymentExecutionStep.paymentSource:
        return RecurringPaymentSourceStep(
          sources: _paymentSources(context),
          selectedId: _selectedSource?.id,
          onSelect: (source) => setState(() => _selectedSource = source),
          onContinue: _continueFromSource,
        );
      case RecurringPaymentExecutionStep.manualRegistration:
        return RecurringPaymentManualRegistrationStep(
          symbolFormatMoney: widget.symbolFormatMoney,
          selectedSource: _selectedSource,
          onSubmit: _submitManual,
        );
      case RecurringPaymentExecutionStep.asaasMethod:
        return RecurringPaymentInstrumentStep(
          onBoleto:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.boletoEntry,
              ),
          onPixQr:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.pixQrEntry,
              ),
          showSavedPixKey: widget.item.recurringPayment.hasPixDestination,
          onSavedPixKey:
              widget.item.recurringPayment.hasPixDestination
                  ? () => setState(() {
                    _store.setMethod(RecurringPaymentMethodType.PIX);
                    _step = RecurringPaymentExecutionStep.amountAndMethod;
                  })
                  : null,
        );
      case RecurringPaymentExecutionStep.amountAndMethod:
        if (_store.state.isManualSource) {
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
        return RecurringPaymentBoletoLineStep(onContinue: _validateBoleto);
      case RecurringPaymentExecutionStep.boletoCamera:
        return RecurringPaymentBoletoCameraStep(
          onDetected: (line) {
            _store.setBoletoLine(line);
            _validateBoleto();
          },
          onTypeManually:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.boletoLine,
              ),
        );
      case RecurringPaymentExecutionStep.boletoConfirmation:
        return RecurringPaymentLocalPreviewStep(
          isPixQr: false,
          expectedAmount: _store.state.payment.amount,
          actualAmount: 487.32,
          variable: _store.state.isVariable,
          sourceName: _selectedSource?.name ?? '',
          recurrenceName: _store.state.payment.name,
          competence: _store.state.item.month.slashLabel,
          symbolFormatMoney: widget.symbolFormatMoney,
          onConfirm: _finishLocalPreview,
          onReview:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.boletoEntry,
              ),
        );
      case RecurringPaymentExecutionStep.boletoValidating:
        return Column(
          children: [
            const SizedBox(height: 24),
            const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
            const SizedBox(height: 12),
            Text(context.l10n.recurringPaymentsExecution_boleto_validating),
            const SizedBox(height: 24),
          ],
        );
      case RecurringPaymentExecutionStep.pixQrEntry:
        return RecurringPaymentPixQrEntryStep(
          onCamera:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.pixQrCamera,
              ),
          onPaste:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.pixQrPaste,
              ),
        );
      case RecurringPaymentExecutionStep.pixQrCamera:
        return RecurringPaymentPixQrCameraStep(
          onDetected: _decodeQr,
          onPaste:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.pixQrPaste,
              ),
        );
      case RecurringPaymentExecutionStep.pixQrPaste:
        return RecurringPaymentPixQrPasteStep(onContinue: _decodeQr);
      case RecurringPaymentExecutionStep.pixQrAmount:
        return RecurringPaymentPixQrAmountStep(
          symbolFormatMoney: widget.symbolFormatMoney,
          initialValue: _qrAmountText,
          onContinue:
              (amount) => setState(() {
                _qrAmountText = amount;
                _qrAmount =
                    double.tryParse(amount.replaceAll(RegExp(r'[^0-9]'), ''))! /
                    100;
                _step = RecurringPaymentExecutionStep.pixQrPreview;
              }),
        );
      case RecurringPaymentExecutionStep.pixQrPreview:
        return RecurringPaymentLocalPreviewStep(
          isPixQr: true,
          expectedAmount: _store.state.payment.amount,
          actualAmount: _qrAmount,
          variable: _store.state.isVariable,
          sourceName: _selectedSource?.name ?? '',
          recurrenceName: _store.state.payment.name,
          competence: _store.state.item.month.slashLabel,
          symbolFormatMoney: widget.symbolFormatMoney,
          onConfirm: _finishLocalPreview,
          onReview:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.pixQrEntry,
              ),
        );
      case RecurringPaymentExecutionStep.localResult:
        return _localResult(context);
      case RecurringPaymentExecutionStep.result:
        return RecurringPaymentExecutionResultStep(
          result: _store.state.result!,
          method: _store.state.method,
          symbolFormatMoney: widget.symbolFormatMoney,
          onClose: () => Navigator.of(context).pop(),
          onRetry:
              () => setState(() {
                _store.setMethod(_store.state.method);
                _step =
                    _store.state.isManualSource
                        ? RecurringPaymentExecutionStep.manualRegistration
                        : RecurringPaymentExecutionStep.asaasMethod;
              }),
          onReviewBoleto:
              () => setState(
                () => _step = RecurringPaymentExecutionStep.boletoLine,
              ),
        );
    }
  }

  List<RecurringPaymentSourceUiModel> _paymentSources(BuildContext context) {
    final banks = context.watch<BankStore>();
    final accounts = context
        .watch<AvailabilityAccountsListStore>()
        .state
        .availabilityAccounts
        .where((account) => account.active);
    final accountSources =
        accounts.map((account) {
          final source = account.source;
          final bankId =
              source is Map<String, dynamic>
                  ? source['bankId'] as String?
                  : null;
          final isAsaas =
              bankId != null &&
              banks.findByBankId(bankId)?.provider?.toUpperCase() == 'ASAAS';

          return RecurringPaymentSourceUiModel(
            id: account.availabilityAccountId,
            availabilityAccountId: account.availabilityAccountId,
            name: account.accountName,
            subtitle:
                isAsaas
                    ? context
                        .l10n
                        .recurringPaymentsExecution_source_asaas_subtitle
                    : context
                        .l10n
                        .recurringPaymentsExecution_source_manual_subtitle,
            capability:
                isAsaas
                    ? RecurringPaymentSourceCapability.asaas
                    : RecurringPaymentSourceCapability.manual,
            isConnected: isAsaas,
            requiresVoucher:
                account.accountType == 'BANK' ||
                account.accountType == 'WALLET',
          );
        }).toList();
    final hasAsaasAccount = accountSources.any((source) => source.isAsaas);
    return [
      if (widget.asaasAvailable && !hasAsaasAccount)
        RecurringPaymentSourceUiModel(
          id: 'asaas-ui-source',
          name: context.l10n.recurringPaymentsExecution_source_asaas,
          subtitle:
              context.l10n.recurringPaymentsExecution_source_asaas_subtitle,
          capability: RecurringPaymentSourceCapability.asaas,
          isConnected: true,
        ),
      ...accountSources,
    ];
  }

  void _continueFromSource() {
    final source = _selectedSource;
    if (source == null) return;
    _store.selectPaymentSource(source);
    _store.setMethod(RecurringPaymentMethodType.BILL);
    setState(
      () =>
          _step =
              source.isAsaas
                  ? RecurringPaymentExecutionStep.asaasMethod
                  : RecurringPaymentExecutionStep.manualRegistration,
    );
  }

  void _goBack() {
    final previous = switch (_step) {
      RecurringPaymentExecutionStep.manualRegistration ||
      RecurringPaymentExecutionStep
          .asaasMethod => RecurringPaymentExecutionStep.paymentSource,
      RecurringPaymentExecutionStep.boletoEntry =>
        RecurringPaymentExecutionStep.asaasMethod,
      RecurringPaymentExecutionStep.boletoLine ||
      RecurringPaymentExecutionStep
          .boletoCamera => RecurringPaymentExecutionStep.boletoEntry,
      RecurringPaymentExecutionStep.boletoValidating =>
        RecurringPaymentExecutionStep.boletoEntry,
      RecurringPaymentExecutionStep.boletoConfirmation =>
        RecurringPaymentExecutionStep.boletoLine,
      RecurringPaymentExecutionStep.pixQrEntry =>
        RecurringPaymentExecutionStep.asaasMethod,
      RecurringPaymentExecutionStep.pixQrCamera ||
      RecurringPaymentExecutionStep
          .pixQrPaste => RecurringPaymentExecutionStep.pixQrEntry,
      RecurringPaymentExecutionStep.pixQrAmount ||
      RecurringPaymentExecutionStep
          .pixQrPreview => RecurringPaymentExecutionStep.pixQrEntry,
      _ => RecurringPaymentExecutionStep.paymentSource,
    };
    setState(() => _step = previous);
  }

  void _showBoletoPreview() {
    setState(() => _step = RecurringPaymentExecutionStep.boletoConfirmation);
  }

  Future<void> _validateBoleto() async {
    setState(() => _step = RecurringPaymentExecutionStep.boletoValidating);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (mounted) _showBoletoPreview();
  }

  void _decodeQr(String payload) {
    // A demo fixture marker represents a QR without an embedded amount.
    final withoutAmount = payload.contains('SEM_VALOR');
    _qrAmount = withoutAmount ? null : 487.32;
    if (withoutAmount && _store.state.isVariable) {
      setState(() => _step = RecurringPaymentExecutionStep.pixQrAmount);
    } else {
      if (withoutAmount) _qrAmount = _store.state.payment.amount;
      setState(() => _step = RecurringPaymentExecutionStep.pixQrPreview);
    }
  }

  void _finishLocalPreview() {
    setState(() => _step = RecurringPaymentExecutionStep.localResult);
  }

  Widget _localResult(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: AppColors.green,
          size: 44,
        ),
        const SizedBox(height: 10),
        Text(
          l10n.recurringPaymentsExecution_preview_ready,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.recurringPaymentsExecution_preview_mode,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.recurringPaymentsExecution_common_close),
        ),
      ],
    );
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
    required MultipartFile? voucher,
  }) async {
    final previewCallback = widget.onManualRegister;
    if (previewCallback != null) {
      final success = await previewCallback(
        paymentDate: paymentDate,
        availabilityAccountId: availabilityAccountId,
        voucher: voucher,
      );
      if (!mounted) return;
      if (success) {
        setState(() => _step = RecurringPaymentExecutionStep.localResult);
      }
      return;
    }

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
    switch (_step) {
      case RecurringPaymentExecutionStep.paymentSource:
        return l10n.recurringPaymentsExecution_source_title;
      case RecurringPaymentExecutionStep.manualRegistration:
        return l10n.recurringPaymentsExecution_manual_title;
      case RecurringPaymentExecutionStep.asaasMethod:
        return l10n.recurringPaymentsExecution_instrument_title;
      case RecurringPaymentExecutionStep.pixQrEntry:
        return l10n.recurringPaymentsExecution_qr_entry_title;
      case RecurringPaymentExecutionStep.pixQrCamera:
        return l10n.recurringPaymentsExecution_qr_entry_title;
      case RecurringPaymentExecutionStep.pixQrPaste:
        return l10n.recurringPaymentsExecution_qr_entry_title;
      case RecurringPaymentExecutionStep.pixQrAmount:
        return l10n.recurringPaymentsExecution_manual_amount_label;
      case RecurringPaymentExecutionStep.pixQrPreview:
        return l10n.recurringPaymentsExecution_qr_found;
      case RecurringPaymentExecutionStep.localResult:
        return l10n.recurringPaymentsExecution_preview_ready;
      case RecurringPaymentExecutionStep.pixConfirmation:
        return l10n.recurringPaymentsExecution_pix_confirm_title;
      case RecurringPaymentExecutionStep.boletoCamera:
        return l10n.recurringPaymentsExecution_boleto_scan_title;
      case RecurringPaymentExecutionStep.boletoValidating:
        return l10n.recurringPaymentsExecution_boleto_validating;
      case RecurringPaymentExecutionStep.boletoConfirmation:
      case RecurringPaymentExecutionStep.boletoEntry:
      case RecurringPaymentExecutionStep.boletoLine:
        return l10n.recurringPaymentsExecution_boleto_confirm_title;
      case RecurringPaymentExecutionStep.result:
        return l10n.recurringPaymentsExecution_sent_title;
      case RecurringPaymentExecutionStep.amountAndMethod:
      case RecurringPaymentExecutionStep.pixKey:
        return l10n.recurringPaymentsExecution_pay_action;
    }
  }
}
