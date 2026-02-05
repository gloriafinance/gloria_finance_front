import 'package:gloria_finance/core/theme/index.dart';
import 'package:flutter/material.dart';

class CardAccountStyle {
  final Color color;
  final IconData icon;
  final String typeName;

  CardAccountStyle(
      {required this.color, required this.icon, required this.typeName});
}

CardAccountStyle getCardAccountStyle(String accountType) {
  switch (accountType) {
    case 'BANK':
      return CardAccountStyle(
        color: AppColors.blue,
        icon: Icons.account_balance,
        typeName: 'Conta Bancária',
      );
    case 'CASH':
      return CardAccountStyle(
        color: AppColors.green,
        icon: Icons.attach_money,
        typeName: 'Dinheiro',
      );
    case 'INVESTMENT':
      return CardAccountStyle(
        color: AppColors.mustard,
        icon: Icons.trending_up,
        typeName: 'Investimento',
      );
    case 'WALLET':
      return CardAccountStyle(
        color: AppColors.purple,
        icon: Icons.account_balance_wallet,
        typeName: 'Carteira Digital',
      );
    default:
      return CardAccountStyle(
        color: AppColors.purple,
        icon: Icons.account_balance_wallet,
        typeName: accountType,
      );
  }
}
