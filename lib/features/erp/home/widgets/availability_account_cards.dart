import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/features/auth/pages/login/store/auth_session_store.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/features/erp/widgets/account_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvailabilityAccountCards extends StatelessWidget {
  const AvailabilityAccountCards({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionStore = Provider.of<AuthSessionStore>(context);

    if (sessionStore.state.session.roles.length == 1 &&
        sessionStore.state.session.isMember()) {
      return Center(
        child: Text(context.l10n.erp_home_welcome_member),
      );
    }

    final accountsStore = Provider.of<AvailabilityAccountsListStore>(context);
    final accounts = accountsStore.state.availabilityAccounts;

    if (accounts.isEmpty) {
      return Center(
        child: Text(context.l10n.erp_home_no_availability_accounts),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Text(
            context.l10n.erp_home_availability_summary_title,
            style: TextStyle(
              fontSize: 18,
              fontFamily: AppFonts.fontTitle,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          isMobile(context)
              ? _buildMobileAccountsView(context, accounts)
              : _buildDesktopAccountsView(accounts),
        ],
      ),
    );
  }

  Widget _buildMobileAccountsView(BuildContext context, dynamic accounts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            context.l10n.erp_home_availability_swipe_hint,
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
      spacing: 40,
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
