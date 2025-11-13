// lib/finance/reports/pages/dre/widgets/dre_cards.dart

import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';

import '../models/dre_model.dart';

class DRECards extends StatelessWidget {
  final DREModel data;

  const DRECards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobileView = constraints.maxWidth < 768;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildCard(
              'Receita Bruta',
              data.receitaBruta,
              const Color(0xFF1B998B),
              isMobileView,
            ),
            _buildCard(
              'Receita Líquida',
              data.receitaLiquida,
              const Color(0xFF2EC4B6),
              isMobileView,
            ),
            _buildCard(
              'Custos Diretos',
              data.custosDiretos,
              const Color(0xFF8ECAE6),
              isMobileView,
            ),
            _buildCard(
              'Resultado Bruto',
              data.resultadoBruto,
              const Color(0xFF023047),
              isMobileView,
            ),
            _buildCard(
              'Despesas Operacionais',
              data.despesasOperacionais,
              const Color(0xFFD62839),
              isMobileView,
            ),
            _buildCard(
              'Resultado Operacional',
              data.resultadoOperacional,
              const Color(0xFFFFB703),
              isMobileView,
            ),
            _buildCard(
              'Resultados Extraordinários',
              data.resultadosExtraordinarios,
              const Color(0xFF6A4C93),
              isMobileView,
            ),
            _buildCard(
              'Resultado Líquido',
              data.resultadoLiquido,
              AppColors.purple,
              isMobileView,
              isHighlight: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(
    String title,
    double value,
    Color color,
    bool isMobile, {
    bool isHighlight = false,
  }) {
    final cardWidth = isMobile ? double.infinity : 230.0;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight ? color : Colors.grey.shade300,
          width: isHighlight ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: isHighlight ? 16 : 14,
                    color: Colors.grey.shade700,
                    fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            formatCurrency(value),
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: isHighlight ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: value < 0 ? Colors.red.shade700 : color,
            ),
          ),
        ],
      ),
    );
  }
}
