import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvailabilityAccountCards extends StatelessWidget {
  const AvailabilityAccountCards({super.key});

  @override
  Widget build(BuildContext context) {
    final accountsStore = Provider.of<AvailabilityAccountsListStore>(context);
    final accounts = accountsStore.state.availabilityAccounts;

    if (accounts.isEmpty) {
      return const Center(
        child: Text('Nenhuma conta de disponibilidade encontrada'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Text(
            'Resumo de contas de disponibilidade',
            style: TextStyle(
              fontSize: 18,
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          isMobile(context)
              ? _buildMobileAccountsView(accounts)
              : _buildDesktopAccountsView(accounts),
        ],
      ),
    );
  }

  Widget _buildMobileAccountsView(dynamic accounts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Deslize para ver todas as contas',
            style: TextStyle(
              fontSize: 14,
              fontFamily: AppFonts.fontText,
              color: AppColors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.75,
                margin: const EdgeInsets.only(right: 16.0),
                child: _buildAccountCard(account),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopAccountsView(dynamic accounts) {
    List<Widget> cards = [];
    for (var account in accounts) {
      cards.add(
        SizedBox(
          width: 320,
          height: 150,
          child: _buildAccountCard(account),
        ),
      );
    }

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.start,
      children: cards,
    );
  }

  Widget _buildAccountCard(dynamic account) {
    final cardData = _getCardStyle(account.accountType);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icono con color
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cardData.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      cardData.icon,
                      color: cardData.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nombre y tipo de cuenta
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.accountName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.fontTitle,
                            color: AppColors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cardData.typeName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: AppFonts.fontSubTitle,
                            color: AppColors.grey,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Monto con color acorde al tipo de cuenta
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: cardData.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  CurrencyFormatter.formatCurrency(account.balance ?? 0.0),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.fontTitle,
                    color: cardData.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardStyle {
  final Color color;
  final IconData icon;
  final String typeName;

  CardStyle({required this.color, required this.icon, required this.typeName});
}

// Método para obtener estilo de tarjeta basado en el tipo de cuenta
CardStyle _getCardStyle(String accountType) {
  switch (accountType) {
    case 'BANK':
      return CardStyle(
        color: AppColors.blue,
        icon: Icons.account_balance,
        typeName: 'Conta Bancária',
      );
    case 'CASH':
      return CardStyle(
        color: AppColors.green,
        icon: Icons.attach_money,
        typeName: 'Dinheiro',
      );
    case 'INVESTMENT':
      return CardStyle(
        color: AppColors.mustard,
        icon: Icons.trending_up,
        typeName: 'Investimento',
      );
    case 'WALLET':
      return CardStyle(
        color: AppColors.purple,
        icon: Icons.account_balance_wallet,
        typeName: 'Carteira Digital',
      );
    default:
      return CardStyle(
        color: AppColors.purple,
        icon: Icons.account_balance_wallet,
        typeName: accountType,
      );
  }
}
