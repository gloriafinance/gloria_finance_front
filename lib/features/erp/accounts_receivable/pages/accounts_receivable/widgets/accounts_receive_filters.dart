import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/accounts_receivable_model.dart';
import '../store/accounts_receivable_store.dart';

class AccountsReceiveFilters extends StatefulWidget {
  const AccountsReceiveFilters({super.key});

  @override
  State<StatefulWidget> createState() => _AccountsReceiveFilters();
}

class _AccountsReceiveFilters extends State<AccountsReceiveFilters> {
  bool isExpandedFilter = false;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountsReceivableStore>(context);

    return isMobile(context) ? _layoutMobile(store) : _layoutDesktop(store);
  }

  Widget _layoutDesktop(AccountsReceivableStore store) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: _debtor(store)),
              SizedBox(width: 10),
              Expanded(flex: 1, child: _status(store)),
              SizedBox(width: 10),
              Expanded(flex: 2, child: _dateStart(store)),
              SizedBox(width: 10),
              Expanded(flex: 2, child: _dateEnd(store)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _clearButton(store),
              SizedBox(width: 12),
              _applyFilterButton(store),
            ],
          ),
        ],
      ),
    );
  }

  Widget _layoutMobile(AccountsReceivableStore store) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          isExpandedFilter = isExpanded;
          setState(() {});
        },
        animationDuration: const Duration(milliseconds: 500),
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: isExpandedFilter,
            headerBuilder: (context, isOpen) {
              return ListTile(
                title: Text(
                  l10n.common_filters_upper,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.fontTitle,
                    color: AppColors.purple,
                  ),
                ),
              );
            },
            body: Column(
              children: [
                Row(children: [Expanded(child: _status(store))]),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _dateStart(store)),
                    SizedBox(width: 10),
                    Expanded(child: _dateEnd(store)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _clearButton(store)),
                    SizedBox(width: 10),
                    Expanded(child: _applyFilterButton(store)),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _debtor(AccountsReceivableStore store) {
    return Input(
      label: context.l10n.accountsReceivable_form_field_debtor_name,
      keyboardType: TextInputType.number,
      initialValue: store.state.filter.debtor,
      onChanged: (value) {
        store.setDebtor(value);
      },
    );
  }

  Widget _status(AccountsReceivableStore store) {
    AccountsReceivableStatus? status;
    try {
      status = AccountsReceivableStatus.values.firstWhere(
        (e) => e.apiValue == store.state.filter.status,
      );
    } catch (e) {
      status = null;
    }

    return Dropdown(
      label: context.l10n.common_status,
      initialValue: status?.friendlyName,
      items:
          AccountsReceivableStatus.values
              .map((status) => status.friendlyName)
              .toList(),
      onChanged: (value) {
        store.setStatus(value);
      },
    );
  }

  Widget _dateStart(AccountsReceivableStore store) {
    return Input(
      label: context.l10n.common_start_date,
      keyboardType: TextInputType.number,
      initialValue: store.state.filter.startDate,
      onChanged: (value) {},
      onTap: () {
        selectDate(context).then((picked) {
          if (picked == null) return;
          store.setStartDate(convertDateFormatToDDMMYYYY(picked.toString()));
        });
      },
    );
  }

  Widget _dateEnd(AccountsReceivableStore store) {
    return Input(
      label: context.l10n.common_end_date,
      keyboardType: TextInputType.number,
      initialValue: store.state.filter.endDate,
      onChanged: (value) {},
      onTap: () {
        selectDate(context).then((picked) {
          if (picked == null) return;

          store.setEndDate(convertDateFormatToDDMMYYYY(picked.toString()));
        });
      },
    );
  }

  Widget _applyFilterButton(AccountsReceivableStore store) {
    final isLoading = store.state.makeRequest;
    final l10n = context.l10n;
    return ButtonActionTable(
      color: AppColors.blue,
      text: isLoading ? l10n.common_loading : l10n.common_apply_filters,
      icon: isLoading ? Icons.hourglass_bottom : Icons.search,
      onPressed: () {
        if (!isLoading) {
          isExpandedFilter = false;
          setState(() {});
          store.apply();
        }
      },
    );
  }

  Widget _clearButton(AccountsReceivableStore store) {
    return ButtonActionTable(
      icon: Icons.clear,
      color: AppColors.mustard,
      text: context.l10n.common_clear_filters,
      onPressed: () => store.clearFilters(),
    );
  }
}
