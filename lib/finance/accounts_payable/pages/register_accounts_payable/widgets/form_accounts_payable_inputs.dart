import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/providers/pages/suppliers/store/suppliers_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/form_accounts_payable_store.dart';
import '../validators/form_accounts_payable_validator.dart';

final validator = FormAccountsPayableValidator();

Widget description(FormAccountsPayableStore formStore) {
  return Input(
    label: 'Descrição',
    onChanged: (value) => formStore.setDescription(value),
    onValidator: validator.byField(formStore.state, 'description'),
  );
}

Widget supplierDropdown(FormAccountsPayableStore formStore) {
  return Consumer<SuppliersListStore>(
    builder: (context, supplierStore, child) {
      return Dropdown(
        label: 'Fornecedor',
        items: supplierStore.state.suppliers.map((e) => e.name).toList(),
        onChanged: (value) {
          final selectedSupplier =
              supplierStore.state.suppliers.firstWhere((e) => e.name == value);
          formStore.setSupplier(
              selectedSupplier.supplierId!, selectedSupplier.name);
        },
        onValidator: validator.byField(formStore.state, 'supplierId'),
      );
    },
  );
}

// Widget para mostrar las cuotas
Widget installmentsList(
    BuildContext context, FormAccountsPayableStore formStore) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Listado de parcelas',
          style: const TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 15)),
      const SizedBox(height: 8),
      formStore.state.installments.isEmpty
          ? Center(
              child: Text('Nenhuma parcela adicionada',
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                  )),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: formStore.state.installments.length,
              itemBuilder: (context, index) {
                final installment = formStore.state.installments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text('Valor: ${formatCurrency(installment.amount)}'),
                    subtitle:
                        Text('Data de vencimento: ${installment.dueDate}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => formStore.removeInstallment(index),
                    ),
                  ),
                );
              },
            ),
    ],
  );
}
