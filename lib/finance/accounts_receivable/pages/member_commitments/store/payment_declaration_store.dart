import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/finance/accounts_receivable/accounts_receivable_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../models/installment_model.dart';
import '../../../models/index.dart';
import '../state/payment_declaration_state.dart';

class PaymentDeclarationStore extends ChangeNotifier {
  final AccountsReceivableService service;
  final bool showToast;
  PaymentDeclarationState state = const PaymentDeclarationState();

  PaymentDeclarationStore({AccountsReceivableService? service, this.showToast = true})
      : service = service ?? AccountsReceivableService();

  void setAvailabilityAccount(String value) {
    state = state.copyWith(availabilityAccountId: value);
    notifyListeners();
  }

  void setAmount(double value) {
    state = state.copyWith(amount: value);
    notifyListeners();
  }

  void setVoucher(MultipartFile? file) {
    state = state.copyWith(voucher: file);
    notifyListeners();
  }

  Future<bool> submit(
    AccountsReceivableModel commitment,
    InstallmentModel installment,
  ) async {
    if (commitment.accountReceivableId == null || installment.installmentId == null) {
      state = state.copyWith(errorMessage: 'Registro do compromisso incompleto.');
      notifyListeners();
      return false;
    }

    if (state.availabilityAccountId == null || state.availabilityAccountId!.isEmpty) {
      state = state.copyWith(errorMessage: 'Selecione a conta de origem para o pagamento.');
      notifyListeners();
      return false;
    }

    if (state.amount == null || state.amount! <= 0) {
      state = state.copyWith(errorMessage: 'Informe um valor maior que zero.');
      notifyListeners();
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null, validationErrors: {});
    notifyListeners();

    try {
      final session = await AuthPersistence().restore();
      await service.declareMemberPayment(
        PaymentDeclarationModel(
          accountReceivableId: commitment.accountReceivableId!,
          installmentId: installment.installmentId!,
          availabilityAccountId: state.availabilityAccountId!,
          amount: state.amount!,
          voucher: state.voucher,
          memberId: session.memberId,
        ),
      );

      state = state.copyWith(isSubmitting: false);
      notifyListeners();
      if (showToast) {
        Toast.showMessage('Pagamento declarado! Agora está em validação.', ToastType.success);
      }
      return true;
    } on DioException catch (e) {
      final validationErrors = <String, String>{};
      final data = e.response?.data;
      if (e.response?.statusCode == 422 && data is Map<String, dynamic>) {
        for (final entry in data.entries) {
          if (entry.value is List && (entry.value as List).isNotEmpty) {
            validationErrors[entry.key] = (entry.value as List).first.toString();
          } else if (entry.value is String) {
            validationErrors[entry.key] = entry.value;
          }
        }
      }

      state = state.copyWith(
        isSubmitting: false,
        validationErrors: validationErrors,
        errorMessage: validationErrors.isNotEmpty
            ? validationErrors.values.join('\n')
            : 'Não foi possível registrar o pagamento. Tente novamente.',
      );
      notifyListeners();
      return false;
    }
  }
}
