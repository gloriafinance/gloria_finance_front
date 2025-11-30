import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:church_finance_bk/features/erp/settings/banks/models/bank_model.dart';
import 'package:church_finance_bk/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BankTable extends StatelessWidget {
  const BankTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<BankStore>();
    final state = store.state;

    if (state.isLoading) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 40.0),
        child: const CircularProgressIndicator(),
      );
    }

    if (state.banks.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: const Center(
          child: Text(
            'Nenhum banco cadastrado.',
            style: TextStyle(fontFamily: AppFonts.fontText),
          ),
        ),
      );
    }

    return CustomTable(
      headers: const [
        'Nome',
        'Tag',
        'Tipo de conta',
        'Código do banco',
        'Agência',
        'Conta',
        'Status',
      ],
      data: FactoryDataTable<BankModel>(
        data: state.banks,
        dataBuilder: (bank) => _mapToRow(bank),
      ),
      actionBuilders: [
        (bank) => ButtonActionTable(
          color: AppColors.blue,
          text: 'Editar',
          onPressed: () => _navigateToEdit(context, bank as BankModel),
          icon: Icons.edit_outlined,
        ),
      ],
    );
  }

  List<dynamic> _mapToRow(BankModel bank) {
    return [
      bank.name,
      bank.tag,
      bank.accountType.friendlyName,
      bank.bankInstruction.codeBank,
      bank.bankInstruction.agency,
      bank.bankInstruction.account,
      bank.active
          ? tagStatus(AppColors.green, 'Ativo')
          : tagStatus(Colors.red, 'Inativo'),
    ];
  }

  void _navigateToEdit(BuildContext context, BankModel bank) {
    GoRouter.of(context).go('/banks/edit/${bank.bankId}', extra: bank);
  }
}
