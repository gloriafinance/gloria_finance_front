import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/features/erp/settings/banks/store/bank_store.dart';
import 'package:church_finance_bk/features/erp/bank_statements/models/bank_statement_model.dart';
import 'package:church_finance_bk/features/erp/bank_statements/store/bank_statement_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankStatementFilters extends StatefulWidget {
  const BankStatementFilters({super.key});

  @override
  State<BankStatementFilters> createState() => _BankStatementFiltersState();
}

class _BankStatementFiltersState extends State<BankStatementFilters> {
  bool isExpandedFilter = false;

  static final List<String> _monthNames = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  @override
  Widget build(BuildContext context) {
    final bankStore = context.watch<BankStore>();
    final store = context.watch<BankStatementListStore>();

    return isMobile(context)
        ? _layoutMobile(bankStore, store)
        : _layoutDesktop(bankStore, store);
  }

  Widget _layoutDesktop(BankStore bankStore, BankStatementListStore store) {
    final filter = store.state.filter;
    final isLoading = store.state.loading;
    final yearNow = DateTime.now().year;
    final years = List<int>.generate(5, (index) => yearNow - index);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtros',
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 230,
                child: DropdownButtonFormField<String?>(
                  value: filter.bankId,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Todos os bancos'),
                    ),
                    ...bankStore.state.banks.map(
                      (bank) => DropdownMenuItem<String?>(
                        value: bank.bankId,
                        child: Text('${bank.name} (${bank.tag})'),
                      ),
                    ),
                  ],
                  onChanged: (value) => store.setBank(value),
                  decoration: _decoration('Banco'),
                ),
              ),
              SizedBox(
                width: 200,
                child:
                    DropdownButtonFormField<BankStatementReconciliationStatus?>(
                      value: filter.status,
                      items: const [
                        DropdownMenuItem<BankStatementReconciliationStatus?>(
                          value: null,
                          child: Text('Todos os status'),
                        ),
                        DropdownMenuItem(
                          value: BankStatementReconciliationStatus.pending,
                          child: Text('Pendentes'),
                        ),
                        DropdownMenuItem(
                          value: BankStatementReconciliationStatus.unmatched,
                          child: Text('Não conciliados'),
                        ),
                        DropdownMenuItem(
                          value: BankStatementReconciliationStatus.reconciled,
                          child: Text('Conciliados'),
                        ),
                      ],
                      onChanged: (value) => store.setStatus(value),
                      decoration: _decoration('Status'),
                    ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<int?>(
                  value: filter.month,
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Todos os meses'),
                    ),
                    ...List.generate(
                      12,
                      (index) => DropdownMenuItem<int?>(
                        value: index + 1,
                        child: Text(_monthNames[index]),
                      ),
                    ),
                  ],
                  onChanged: (value) => store.setMonth(value),
                  decoration: _decoration('Mês'),
                ),
              ),
              SizedBox(
                width: 160,
                child: DropdownButtonFormField<int?>(
                  value: filter.year,
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Todos os anos'),
                    ),
                    ...years.map(
                      (year) => DropdownMenuItem<int?>(
                        value: year,
                        child: Text(year.toString()),
                      ),
                    ),
                  ],
                  onChanged: (value) => store.setYear(value),
                  decoration: _decoration('Ano'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (filter.hasAnyFilter)
                ButtonActionTable(
                  color: AppColors.greyMiddle,
                  text: 'Limpar filtros',
                  icon: Icons.clear,
                  onPressed: () {
                    store.clearFilters();
                    store.fetchStatements();
                  },
                ),

              const SizedBox(width: 12),
              ButtonActionTable(
                color: AppColors.blue,
                text: isLoading ? 'Carregando...' : 'Aplicar filtros',
                icon: isLoading ? Icons.hourglass_bottom : Icons.search,
                onPressed: () {
                  if (!isLoading) {
                    store.fetchStatements();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _layoutMobile(BankStore bankStore, BankStatementListStore store) {
    final filter = store.state.filter;
    final isLoading = store.state.loading;
    final yearNow = DateTime.now().year;
    final years = List<int>.generate(5, (index) => yearNow - index);

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
                  "FILTROS",
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
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: filter.bankId,
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Todos os bancos'),
                          ),
                          ...bankStore.state.banks.map(
                            (bank) => DropdownMenuItem<String?>(
                              value: bank.bankId,
                              child: Text('${bank.name} (${bank.tag})'),
                            ),
                          ),
                        ],
                        onChanged: (value) => store.setBank(value),
                        decoration: _decoration('Banco'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<
                        BankStatementReconciliationStatus?
                      >(
                        value: filter.status,
                        items: const [
                          DropdownMenuItem<BankStatementReconciliationStatus?>(
                            value: null,
                            child: Text('Todos os status'),
                          ),
                          DropdownMenuItem(
                            value: BankStatementReconciliationStatus.pending,
                            child: Text('Pendentes'),
                          ),
                          DropdownMenuItem(
                            value: BankStatementReconciliationStatus.unmatched,
                            child: Text('Não conciliados'),
                          ),
                          DropdownMenuItem(
                            value: BankStatementReconciliationStatus.reconciled,
                            child: Text('Conciliados'),
                          ),
                        ],
                        onChanged: (value) => store.setStatus(value),
                        decoration: _decoration('Status'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        value: filter.month,
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('Todos os meses'),
                          ),
                          ...List.generate(
                            12,
                            (index) => DropdownMenuItem<int?>(
                              value: index + 1,
                              child: Text(_monthNames[index]),
                            ),
                          ),
                        ],
                        onChanged: (value) => store.setMonth(value),
                        decoration: _decoration('Mês'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int?>(
                        value: filter.year,
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('Todos os anos'),
                          ),
                          ...years.map(
                            (year) => DropdownMenuItem<int?>(
                              value: year,
                              child: Text(year.toString()),
                            ),
                          ),
                        ],
                        onChanged: (value) => store.setYear(value),
                        decoration: _decoration('Ano'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (filter.hasAnyFilter)
                      Expanded(
                        child: ButtonActionTable(
                          icon: Icons.clear,
                          color: AppColors.mustard,
                          text: 'Limpar filtros',
                          onPressed: () {
                            isExpandedFilter = false;
                            setState(() {});
                            store.clearFilters();
                            store.fetchStatements();
                          },
                        ),
                      ),
                    if (filter.hasAnyFilter) const SizedBox(width: 10),
                    Expanded(
                      child: ButtonActionTable(
                        color: AppColors.blue,
                        text: isLoading ? 'Carregando...' : 'Aplicar filtros',
                        icon: isLoading ? Icons.hourglass_bottom : Icons.search,
                        onPressed: () {
                          if (!isLoading) {
                            isExpandedFilter = false;
                            setState(() {});
                            store.fetchStatements();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: AppColors.purple,
        fontFamily: AppFonts.fontSubTitle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.greyMiddle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.greyMiddle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.blue),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
