import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_types.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../models/installment_model.dart';
import '../state/form_accounts_payable_state.dart';
import '../store/form_accounts_payable_store.dart';
import '../validators/form_accounts_payable_validator.dart';

class InstallmentAccountPayableForm extends StatefulWidget {
  final FormAccountsPayableStore formStore;
  final FormAccountsPayableValidator validator;
  final bool showValidationMessages;

  const InstallmentAccountPayableForm({
    super.key,
    required this.formStore,
    required this.validator,
    required this.showValidationMessages,
  });

  @override
  State<InstallmentAccountPayableForm> createState() =>
      _InstallmentAccountPayableFormState();
}

class _InstallmentAccountPayableFormState
    extends State<InstallmentAccountPayableForm> {
  @override
  Widget build(BuildContext context) {
    final state = widget.formStore.state;

    switch (state.paymentMode) {
      case AccountsPayablePaymentMode.single:
        return _buildSinglePayment(state);
      case AccountsPayablePaymentMode.manual:
        return _buildManualInstallments(state);
      case AccountsPayablePaymentMode.automatic:
        return _buildAutomaticInstallments(state);
    }
  }

  Widget _buildSinglePayment(FormAccountsPayableState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Input(
          label: 'Valor total',
          initialValue: state.totalAmount > 0
              ? CurrencyFormatter.formatCurrency(state.totalAmount)
              : '',
          keyboardType: TextInputType.number,
          inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
          onChanged: (value) => widget.formStore
              .setTotalAmount(CurrencyFormatter.cleanCurrency(value)),
          onValidator: (_) =>
              widget.validator.errorByKey(state, 'totalAmount'),
        ),
        Input(
          label: 'Data de vencimento',
          initialValue: state.singleDueDate,
          onChanged: widget.formStore.setSingleDueDate,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final pickedDate = await selectDate(context);
            if (pickedDate == null) return;
            final formatted = convertDateFormatToDDMMYYYY(pickedDate.toString());
            widget.formStore.setSingleDueDate(formatted);
          },
          onValidator: (_) =>
              widget.validator.errorByKey(state, 'singleDueDate'),
        ),
        const SizedBox(height: 16),
        _buildInstallmentsPreview(
          emptyMessage:
              'Informe o valor e a data de vencimento para visualizar o resumo.',
          showValidationMessages: widget.showValidationMessages,
        ),
      ],
    );
  }

  Widget _buildManualInstallments(FormAccountsPayableState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonActionTable(
          color: AppColors.blue,
          text: 'Adicionar parcela',
          icon: Icons.add_box_outlined,
          onPressed: _openCreateInstallment,
        ),
        const SizedBox(height: 12),
        _buildInstallmentsPreview(
          enableActions: true,
          onEdit: _openEditInstallment,
          onRemove: widget.formStore.removeInstallment,
          emptyMessage: 'Nenhuma parcela adicionada até o momento.',
          showValidationMessages: widget.showValidationMessages,
        ),
      ],
    );
  }

  Widget _buildAutomaticInstallments(FormAccountsPayableState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 220,
              child: Input(
                label: 'Quantidade de parcelas',
                initialValue: state.automaticInstallments > 0
                    ? state.automaticInstallments.toString()
                    : '',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => widget.formStore.setAutomaticInstallments(
                    int.tryParse(value) ?? 0),
                onValidator: (_) => widget.validator
                    .errorByKey(state, 'automaticInstallments'),
              ),
            ),
            SizedBox(
              width: 220,
              child: Input(
                label: 'Valor por parcela',
                initialValue: state.automaticInstallmentAmount > 0
                    ? CurrencyFormatter
                        .formatCurrency(state.automaticInstallmentAmount)
                    : '',
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyFormatter.getInputFormatters('R\$')],
                onChanged: (value) => widget.formStore
                    .setAutomaticInstallmentAmount(
                        CurrencyFormatter.cleanCurrency(value)),
                onValidator: (_) => widget.validator
                    .errorByKey(state, 'automaticInstallmentAmount'),
              ),
            ),
            SizedBox(
              width: 220,
              child: Input(
                label: 'Primeiro vencimento',
                initialValue: state.automaticFirstDueDate,
                onChanged: widget.formStore.setAutomaticFirstDueDate,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final pickedDate = await selectDate(context);
                  if (pickedDate == null) return;
                  final formatted =
                      convertDateFormatToDDMMYYYY(pickedDate.toString());
                  widget.formStore.setAutomaticFirstDueDate(formatted);
                },
                onValidator: (_) => widget.validator
                    .errorByKey(state, 'automaticFirstDueDate'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ButtonActionTable(
          color: AppColors.blue,
          text: 'Gerar parcelas',
          icon: Icons.calculate_outlined,
          onPressed: _handleGenerateAutomatic,
        ),
        const SizedBox(height: 12),
        _buildInstallmentsPreview(
          emptyMessage:
              'Informe os dados e clique em "Gerar parcelas" para visualizar o cronograma.',
          showValidationMessages: widget.showValidationMessages,
        ),
      ],
    );
  }

  Widget _buildInstallmentsPreview({
    bool enableActions = false,
    void Function(int index)? onEdit,
    void Function(int index)? onRemove,
    required String emptyMessage,
    bool showValidationMessages = false,
  }) {
    final installments = widget.formStore.state.installments;
    final totalAmount = installments.fold<double>(
      0,
      (acc, installment) => acc + installment.amount,
    );

    final errorMessage = showValidationMessages
        ? widget.validator.errorByKey(
            widget.formStore.state,
            'installments',
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo das parcelas',
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 15,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 8),
        if (installments.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyMiddle),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              emptyMessage,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: AppColors.grey,
              ),
            ),
          )
        else
          Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: installments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final installment = installments[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyMiddle),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Parcela ${index + 1}',
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontTitle,
                                  fontSize: 15,
                                  color: AppColors.purple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter
                                    .formatCurrency(installment.amount),
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontSubTitle,
                                  fontSize: 14,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Vencimento: ${installment.dueDate}',
                                style: const TextStyle(
                                  fontFamily: AppFonts.fontSubTitle,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (enableActions)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Editar parcela',
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: AppColors.blue,
                                ),
                                onPressed:
                                    onEdit != null ? () => onEdit(index) : null,
                              ),
                              IconButton(
                                tooltip: 'Remover parcela',
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: onRemove != null
                                    ? () => onRemove(index)
                                    : null,
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total: ${CurrencyFormatter.formatCurrency(totalAmount)}',
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ],
          ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openCreateInstallment() async {
    final result = await _showManualInstallmentDialog(context);
    if (result == null) return;
    widget.formStore.addInstallment(result.amount, result.dueDate);
  }

  Future<void> _openEditInstallment(int index) async {
    final installments = widget.formStore.state.installments;
    if (index < 0 || index >= installments.length) return;

    final current = installments[index];
    final result = await _showManualInstallmentDialog(
      context,
      initial: current,
    );

    if (result == null) return;
    widget.formStore.updateInstallment(index, result.amount, result.dueDate);
  }

  void _handleGenerateAutomatic() {
    final success = widget.formStore.generateAutomaticInstallments();

    if (!success) {
      final errors = widget.validator.validateState(widget.formStore.state);
      final keys = [
        'automaticInstallments',
        'automaticInstallmentAmount',
        'automaticFirstDueDate',
        'installments',
      ];

      String? message;
      for (final key in keys) {
        if (errors.containsKey(key)) {
          message = errors[key];
          break;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message ?? 'Preencha os dados para gerar as parcelas.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Parcelas geradas com sucesso.'),
        backgroundColor: AppColors.green,
      ),
    );
  }

  Future<InstallmentModel?> _showManualInstallmentDialog(
    BuildContext context, {
    InstallmentModel? initial,
  }) async {
    final formKey = GlobalKey<FormState>();
    double amount = initial?.amount ?? 0;
    String dueDate = initial?.dueDate ?? '';

    return showDialog<InstallmentModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      initial == null
                          ? 'Adicionar parcela'
                          : 'Editar parcela',
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 18,
                        color: AppColors.purple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Input(
                      label: 'Valor da parcela',
                      initialValue: amount > 0
                          ? CurrencyFormatter.formatCurrency(amount)
                          : '',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyFormatter.getInputFormatters('R\$'),
                      ],
                      onChanged: (value) {
                        setState(() {
                          amount = CurrencyFormatter.cleanCurrency(value);
                        });
                      },
                      onValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o valor da parcela';
                        }
                        final parsed = CurrencyFormatter.cleanCurrency(value);
                        if (parsed <= 0) {
                          return 'Informe um valor maior que zero';
                        }
                        return null;
                      },
                    ),
                    Input(
                      label: 'Data de vencimento',
                      initialValue: dueDate,
                      onChanged: (value) {
                        setState(() {
                          dueDate = value;
                        });
                      },
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final pickedDate = await selectDate(context);
                        if (pickedDate == null) return;
                        final formatted =
                            convertDateFormatToDDMMYYYY(pickedDate.toString());
                        setState(() {
                          dueDate = formatted;
                        });
                      },
                      onValidator: (_) {
                        if (dueDate.isEmpty) {
                          return 'Selecione a data de vencimento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: initial == null
                            ? 'Adicionar parcela'
                            : 'Atualizar parcela',
                        backgroundColor: AppColors.green,
                        textColor: Colors.black,
                        onPressed: () {
                          if (!(formKey.currentState?.validate() ?? false)) {
                            return;
                          }
                          Navigator.of(context).pop(
                            InstallmentModel(
                              amount: amount,
                              dueDate: dueDate,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
