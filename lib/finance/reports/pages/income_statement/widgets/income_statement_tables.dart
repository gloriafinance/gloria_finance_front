import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/helpers/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:church_finance_bk/helpers/index.dart';

import '../models/income_statement_model.dart';

class IncomeStatementReportSections extends StatelessWidget {
  final IncomeStatementModel data;

  const IncomeStatementReportSections({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Receitas e Despesas por Categoria'),
        const SizedBox(height: 16),
        _buildBreakdown(context, data.breakdown),
        const SizedBox(height: 40),
        _cashFlowSection(),
        const SizedBox(height: 40),
        _costCentersSection(),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: AppFonts.fontTitle,
        color: AppColors.purple,
      ),
    );
  }

  Widget _buildBreakdown(
    BuildContext context,
    List<IncomeStatementBreakdown> breakdown,
  ) {
    if (breakdown.isEmpty) {
      return _emptyMessage('Não há dados de receita e despesa para o período.');
    }

    if (isMobile(context)) {
      return _buildBreakdownCards(breakdown);
    }

    return CustomTable(
      headers: const ['Categoria', 'Entradas', 'Saídas', 'Saldo'],
      data: FactoryDataTable<IncomeStatementBreakdown>(
        data: breakdown,
        dataBuilder: (row) {
          final netText = _StyledText(
            text: _formatCurrency(row.net),
            isNegative: row.net < 0,
          );

          return [
            _buildCategoryCell(row),
            _StyledText(text: _formatCurrency(row.income)),
            _StyledText(text: _formatCurrency(row.expenses)),
            netText,
          ];
        },
      ),
      dataRowMinHeight: 30,
      dataRowMaxHeight: 52,
    );
  }

  Widget _buildBreakdownCards(List<IncomeStatementBreakdown> breakdown) {
    return Column(
      children:
          breakdown.map((row) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.greyLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.category.friendlyName,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    row.category.description,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontSize: 12,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBreakdownMetric(
                    label: 'Entradas',
                    value: _formatCurrency(row.income),
                  ),
                  const SizedBox(height: 6),
                  _buildBreakdownMetric(
                    label: 'Saídas',
                    value: _formatCurrency(row.expenses),
                  ),
                  const SizedBox(height: 6),
                  _buildBreakdownMetric(
                    label: 'Saldo',
                    value: _formatCurrency(row.net),
                    isNegative: row.net < 0,
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildBreakdownMetric({
    required String label,
    required String value,
    bool isNegative = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isNegative ? const Color(0xFFD62839) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCell(IncomeStatementBreakdown row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            row.category.friendlyName,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            row.category.description,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 12,
              height: 1.4,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cashFlowSection() {
    final availability = data.cashFlowSnapshot.availabilityAccounts;
    final totalText =
        'Entradas totais: ${_formatCurrency(availability.income)} | '
        'Saídas totais: ${_formatCurrency(availability.expenses)} | '
        'Saldo consolidado: ${_formatCurrency(availability.total)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Fluxo de Caixa por Conta de Disponibilidade'),
        const SizedBox(height: 8),
        Text(
          totalText,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        availability.accounts.isEmpty
            ? _emptyMessage(
              'Nenhuma movimentação de contas de disponibilidade neste período.',
            )
            : CustomTable(
              headers: const [
                'Conta',
                'Entradas',
                'Saídas',
                'Saldo do período',
              ],
              data: FactoryDataTable<AvailabilityAccountEntry>(
                data: availability.accounts,
                dataBuilder: (item) {
                  return [
                    Text(
                      item.availabilityAccount.accountName,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        color: Colors.black87,
                      ),
                    ),
                    _StyledText(
                      text: CurrencyFormatter.formatCurrency(
                        item.totalInput,
                        symbol: item.availabilityAccount.symbol,
                      ),
                    ),
                    _StyledText(
                      text: CurrencyFormatter.formatCurrency(
                        item.totalOutput,
                        symbol: item.availabilityAccount.symbol,
                      ),
                    ),
                    _StyledText(
                      text: CurrencyFormatter.formatCurrency(
                        item.balance,
                        symbol: item.availabilityAccount.symbol,
                      ),
                      isNegative: item.balance < 0,
                    ),
                  ];
                },
              ),
            ),
      ],
    );
  }

  Widget _costCentersSection() {
    final snapshot = data.cashFlowSnapshot.costCenters;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Uso dos Centros de Custo'),
        const SizedBox(height: 8),
        Text(
          'Total aplicado: ${_formatCurrency(snapshot.total)}',
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        snapshot.costCenters.isEmpty
            ? _emptyMessage('Nenhum centro de custo movimentado neste período.')
            : CustomTable(
              headers: const [
                'Centro de Custo',
                'Total Aplicado',
                'Último Movimento',
              ],
              data: FactoryDataTable<CostCenterUsage>(
                data: snapshot.costCenters,
                dataBuilder: (item) {
                  return [
                    Text(
                      item.costCenter.costCenterName,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        color: Colors.black87,
                      ),
                    ),
                    _StyledText(text: _formatCurrency(item.total)),
                    _StyledText(text: _formatDateTime(item.lastMove)),
                  ];
                },
              ),
            ),
      ],
    );
  }

  Widget _emptyMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: Colors.black45,
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    final formatted = CurrencyFormatter.formatCurrency(value.abs());
    return value < 0 ? '($formatted)' : formatted;
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) {
      return '-';
    }

    final localDate = value.toLocal();
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(localDate);
  }
}

class _StyledText extends StatelessWidget {
  final String text;
  final bool isNegative;

  const _StyledText({required this.text, this.isNegative = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFonts.fontSubTitle,
        color: isNegative ? const Color(0xFFD62839) : Colors.black54,
        fontWeight: isNegative ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
