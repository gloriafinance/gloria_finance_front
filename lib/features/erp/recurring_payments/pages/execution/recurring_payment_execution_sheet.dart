import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/general.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/banks/models/bank_model.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/recurring_payment_competence_model.dart';
import '../../models/recurring_payment_execution_model.dart';
import '../../models/recurring_payment_source_ui_model.dart';
import '../../service/recurring_payment_execution_service.dart';
import '../../store/recurring_payment_execution_store.dart';
import '../../store/recurring_payment_monthly_store.dart';
import 'widgets/recurring_payment_boleto_camera_step.dart';
import 'widgets/recurring_payment_boleto_entry_step.dart';
import 'widgets/recurring_payment_boleto_line_step.dart';
import 'widgets/recurring_payment_confirmation_step.dart';
import 'widgets/recurring_payment_execution_result_step.dart';
import 'widgets/recurring_payment_instrument_step.dart';
import 'widgets/recurring_payment_manual_registration_step.dart';
import 'widgets/recurring_payment_pix_qr_camera_step.dart';
import 'widgets/recurring_payment_pix_qr_entry_step.dart';
import 'widgets/recurring_payment_pix_qr_paste_step.dart';
import 'widgets/recurring_payment_source_step.dart';

/// Passos do fluxo de execução de uma competência.
enum RecurringPaymentExecutionStep {
  sourceSelection,
  amountAndMethod,
  pixQrEntry,
  pixQrCamera,
  pixQrPaste,
  pixConfirmation,
  boletoEntry,
  boletoLine,
  boletoCamera,
  boletoConfirmation,
  result,
}

/// Abre o fluxo de execução de uma competência.
///
/// Com banca conectada, a igreja escolhe primeiro a conta disponível para o
/// débito; sem banca, registra manualmente o pagamento já realizado.
Future<void> openRecurringPaymentExecution(
  BuildContext context, {
  required RecurringPaymentCompetenceModel item,
}) {
  final session = context.read<AuthSessionStore>().state.session;

  if (isMobile(context)) {
    return showDialog<void>(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: SizedBox.expand(
              child: RecurringPaymentExecutionSheet(
                item: item,
                hasBanking: session.asaasConnect,
                symbolFormatMoney: session.symbolFormatMoney,
              ),
            ),
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
    return RecurringPaymentExecutionStep.sourceSelection;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final accounts = context.read<AvailabilityAccountsListStore>();
      if (accounts.state.availabilityAccounts.isEmpty) {
        accounts.searchAvailabilityAccounts();
      }
    });
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
    final mobile = isMobile(context);

    return ChangeNotifierProvider<RecurringPaymentExecutionStore>.value(
      value: _store,
      child: AnimatedBuilder(
        animation: _store,
        builder: (context, _) {
          final header = Row(
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
                child: Padding(
                  padding: EdgeInsets.only(top: mobile ? 8 : 0),
                  child: Text(
                    _title(l10n),
                    style: TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: mobile ? 18 : 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, size: 20),
                color: AppColors.grey,
                tooltip: l10n.recurringPaymentsExecution_common_close,
              ),
            ],
          );
          final period = Text(
            '${item.recurringPayment.name} · ${item.month.slashLabel}',
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: mobile ? 12.5 : 13.5,
              color: const Color(0xFF5F5F5F),
            ),
          );

          if (mobile) {
            return ModalPage(
              title: '',
              width: 560,
              header: header,
              headerSpacing: 2,
              contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              borderRadius: 22,
              useDialog: false,
              scrollable: false,
              expand: true,
              backgroundColor: Colors.white,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: _canGoBack ? 52 : 8),
                    child: period,
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child:
                        _step == RecurringPaymentExecutionStep.sourceSelection
                            ? _content(context)
                            : SingleChildScrollView(child: _content(context)),
                  ),
                ],
              ),
            );
          }

          return Container(
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
                  header,
                  const SizedBox(height: 12),
                  period,
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: _content(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _content(BuildContext context) {
    switch (_step) {
      case RecurringPaymentExecutionStep.sourceSelection:
        return RecurringPaymentSourceStep(
          sources: _paymentSources(context),
          isLoading:
              context.watch<AvailabilityAccountsListStore>().state.makeRequest,
          selectedId: _store.state.source?.id,
          onSelect: _store.setSource,
          onContinue: _continueFromSourceSelection,
          fillAvailableSpace: isMobile(context),
        );
      case RecurringPaymentExecutionStep.amountAndMethod:
        if (!_store.state.usesAsaas) {
          return RecurringPaymentManualRegistrationStep(
            symbolFormatMoney: widget.symbolFormatMoney,
            onSubmit: _submitManual,
          );
        }
        return RecurringPaymentInstrumentStep(
          onPixQr: _selectPixQr,
          onBoleto: _selectBoleto,
        );
      case RecurringPaymentExecutionStep.pixQrEntry:
        return RecurringPaymentPixQrEntryStep(
          onCamera: () => _setStep(RecurringPaymentExecutionStep.pixQrCamera),
          onPaste: () => _setStep(RecurringPaymentExecutionStep.pixQrPaste),
        );
      case RecurringPaymentExecutionStep.pixQrCamera:
        return RecurringPaymentPixQrCameraStep(
          onDetected: _handlePixQr,
          onPaste: () => _setStep(RecurringPaymentExecutionStep.pixQrPaste),
        );
      case RecurringPaymentExecutionStep.pixQrPaste:
        return RecurringPaymentPixQrPasteStep(
          onContinue: _handlePixQr,
          isLoading: _store.state.isDecodingPixQr,
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
          onCheckStatus: _checkPixQrStatus,
          isCheckingStatus: _store.state.makeRequest,
          onRetry:
              () => setState(() {
                _store.setMethod(_store.state.method);
                _step = _initialStep();
              }),
        );
    }
  }

  List<RecurringPaymentSourceUiModel> _paymentSources(BuildContext context) {
    final accounts =
        context
            .watch<AvailabilityAccountsListStore>()
            .state
            .availabilityAccounts
            .where(
              (account) =>
                  account.active && account.accountType != 'INVESTMENT',
            )
            .toList();
    final Iterable<AvailabilityAccountModel> asaasAccounts =
        widget.hasBanking ? accounts.where(_isAsaasAccount) : const [];
    return [
      ...asaasAccounts.map(
        (account) => RecurringPaymentSourceUiModel(
          id: account.availabilityAccountId,
          name: account.accountName,
          subtitle: context.l10n.recurringPaymentsExecution_source_connected,
          capability: RecurringPaymentSourceCapability.asaas,
          availabilityAccountId: account.availabilityAccountId,
        ),
      ),
      ...accounts
          .where((account) => !_isAsaasAccount(account))
          .map(
            (account) => RecurringPaymentSourceUiModel(
              id: account.availabilityAccountId,
              name: account.accountName,
              subtitle: _accountTypeLabel(context, account.accountType),
              capability: RecurringPaymentSourceCapability.manual,
              availabilityAccountId: account.availabilityAccountId,
              requiresVoucher:
                  account.accountType == 'BANK' ||
                  account.accountType == 'WALLET',
            ),
          ),
    ];
  }

  bool _isAsaasAccount(AvailabilityAccountModel account) {
    if (account.accountType != 'BANK' || account.source is! Map) return false;
    final bank = account.getSource();
    if (bank is! BankModel) return false;
    if (!bank.active) return false;
    return bank.name.toLowerCase() == 'asaas' ||
        bank.tag.toLowerCase() == 'asaas';
  }

  String _accountTypeLabel(BuildContext context, String accountType) {
    final l10n = context.l10n;
    return switch (accountType) {
      'BANK' => l10n.settings_availability_account_type_bank,
      'WALLET' => l10n.settings_availability_account_type_wallet,
      'CASH' => l10n.settings_availability_account_type_cash,
      _ => accountType,
    };
  }

  void _continueFromSourceSelection() {
    setState(() => _step = RecurringPaymentExecutionStep.amountAndMethod);
  }

  void _setStep(RecurringPaymentExecutionStep step) {
    if (mounted) setState(() => _step = step);
  }

  void _selectPixQr() {
    _store.setMethod(RecurringPaymentMethodType.PIX_QR);
    _setStep(RecurringPaymentExecutionStep.pixQrEntry);
  }

  void _selectBoleto() {
    _store.setMethod(RecurringPaymentMethodType.BILL);
    _setStep(RecurringPaymentExecutionStep.boletoEntry);
  }

  Future<void> _handlePixQr(String payload) async {
    final decoded = await _store.decodePixQr(payload);
    if (!mounted) return;
    if (!decoded) {
      if (_step == RecurringPaymentExecutionStep.pixQrCamera) {
        _setStep(RecurringPaymentExecutionStep.pixQrPaste);
      }
      Toast.showMessage(
        context.l10n.recurringPaymentsExecution_qr_invalid,
        ToastType.error,
      );
      return;
    }
    _setStep(RecurringPaymentExecutionStep.pixConfirmation);
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

  Future<void> _checkPixQrStatus() async {
    setState(() {});
    final result = await _store.reconcilePixQr();
    if (!mounted) return;
    setState(() {});
    if (result == null) {
      Toast.showMessage(
        context.l10n.recurringPaymentsExecution_error_pay,
        ToastType.error,
      );
      return;
    }
    context.read<RecurringPaymentMonthlyStore>().load(force: true);
  }

  Future<void> _submitManual({
    required String paymentDate,
    required String availabilityAccountId,
    MultipartFile? voucher,
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
    if (!widget.hasBanking &&
        _step != RecurringPaymentExecutionStep.sourceSelection) {
      return l10n.recurringPaymentsExecution_manual_title;
    }

    switch (_step) {
      case RecurringPaymentExecutionStep.sourceSelection:
        return l10n.recurringPaymentsExecution_source_title;
      case RecurringPaymentExecutionStep.amountAndMethod:
        return _store.state.usesAsaas
            ? l10n.recurringPaymentsExecution_method_title
            : l10n.recurringPaymentsExecution_manual_title;
      case RecurringPaymentExecutionStep.pixQrEntry:
        return l10n.recurringPaymentsExecution_instrument_qr;
      case RecurringPaymentExecutionStep.pixQrCamera:
        return l10n.recurringPaymentsExecution_qr_camera;
      case RecurringPaymentExecutionStep.pixQrPaste:
        return l10n.recurringPaymentsExecution_qr_paste;
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
      _step != RecurringPaymentExecutionStep.result && _step != _initialStep();

  void _goBack() {
    setState(() {
      _step = switch (_step) {
        RecurringPaymentExecutionStep.sourceSelection =>
          RecurringPaymentExecutionStep.sourceSelection,
        RecurringPaymentExecutionStep.amountAndMethod =>
          RecurringPaymentExecutionStep.sourceSelection,
        RecurringPaymentExecutionStep.pixQrEntry ||
        RecurringPaymentExecutionStep
            .boletoEntry => RecurringPaymentExecutionStep.amountAndMethod,
        RecurringPaymentExecutionStep.pixQrCamera ||
        RecurringPaymentExecutionStep
            .pixQrPaste => RecurringPaymentExecutionStep.pixQrEntry,
        RecurringPaymentExecutionStep.pixConfirmation =>
          RecurringPaymentExecutionStep.pixQrEntry,
        RecurringPaymentExecutionStep.boletoLine ||
        RecurringPaymentExecutionStep
            .boletoCamera => RecurringPaymentExecutionStep.boletoEntry,
        RecurringPaymentExecutionStep.boletoConfirmation =>
          RecurringPaymentExecutionStep.boletoLine,
        RecurringPaymentExecutionStep.result =>
          RecurringPaymentExecutionStep.sourceSelection,
      };
    });
  }
}
