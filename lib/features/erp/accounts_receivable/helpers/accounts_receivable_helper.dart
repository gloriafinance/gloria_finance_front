import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:flutter/widgets.dart';

import '../models/accounts_receivable_model.dart';

String getAccountsReceivableTypeLabel(
  BuildContext context,
  AccountsReceivableType type,
) {
  final l10n = context.l10n;
  switch (type) {
    case AccountsReceivableType.CONTRIBUTION:
      return l10n.accountsReceivable_type_contribution_title;
    case AccountsReceivableType.SERVICE:
      return l10n.accountsReceivable_type_service_title;
    case AccountsReceivableType.INTERINSTITUTIONAL:
      return l10n.accountsReceivable_type_interinstitutional_title;
    case AccountsReceivableType.RENTAL:
      return l10n.accountsReceivable_type_rental_title;
    case AccountsReceivableType.LOAN:
      return l10n.accountsReceivable_type_loan_title;
    case AccountsReceivableType.FINANCIAL:
      return l10n.accountsReceivable_type_financial_title;
    case AccountsReceivableType.LEGAL:
      return l10n.accountsReceivable_type_legal_title;
  }
}

