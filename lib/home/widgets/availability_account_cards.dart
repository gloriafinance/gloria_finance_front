import 'package:church_finance_bk/auth/pages/login/store/auth_session_store.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/finance/widgets/account_style.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvailabilityAccountCards extends StatelessWidget {
  const AvailabilityAccountCards({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionStore = Provider.of<AuthSessionStore>(context);

    if (sessionStore.state.session.roles.length == 1 &&
        sessionStore.state.session.isMember()) {
      return const Center(child: Text('Seja bem-vindo ao Church Finance!\n\n'));
    }

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
      cards.add(_buildAccountCard(account));
    }

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.start,
      children: cards,
    );
  }

  Widget _buildAccountCard(dynamic account) {
    final cardData = getCardAccountStyle(account.accountType);

    return CardAmount(
      title: account.accountName,
      amount: account.balance,
      bgColor: cardData.color,
      subtitle: cardData.typeName,
      symbol: account.symbol,
      icon: cardData.icon,
    );
  }
}
