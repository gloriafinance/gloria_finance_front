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
              context,
              'Receita Bruta',
              '💰',
              'Total de dízimos, ofertas e doações recebidas',
              data.receitaBruta,
              const Color(0xFF1B998B),
              isMobileView,
            ),
            _buildCard(
              context,
              'Receita Líquida',
              '💵',
              'Receita bruta menos devoluções e ajustes',
              data.receitaLiquida,
              const Color(0xFF2EC4B6),
              isMobileView,
            ),
            _buildCard(
              context,
              'Custos Diretos',
              '⚙️',
              'Gastos de eventos, materiais e atividades específicas',
              data.custosDiretos,
              const Color(0xFF8ECAE6),
              isMobileView,
            ),
            _buildCard(
              context,
              'Resultado Bruto',
              '🧮',
              'Receita líquida menos custos diretos',
              data.resultadoBruto,
              const Color(0xFF023047),
              isMobileView,
            ),
            _buildCard(
              context,
              'Despesas Operacionais',
              '🏢',
              'Gastos do dia a dia: energia, água, salários, limpeza',
              data.despesasOperacionais,
              const Color(0xFFD62839),
              isMobileView,
            ),
            _buildCard(
              context,
              'Resultado Operacional',
              '📈',
              'Resultado bruto menos despesas operacionais',
              data.resultadoOperacional,
              const Color(0xFFFFB703),
              isMobileView,
            ),
            _buildCard(
              context,
              'Resultados Extraordinários',
              '💫',
              'Ingressos ou gastos eventuais fora da rotina',
              data.resultadosExtraordinarios,
              const Color(0xFF6A4C93),
              isMobileView,
            ),
            _buildCard(
              context,
              'Resultado Líquido',
              '📊',
              'Resultado final do período (superávit ou déficit)',
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
    BuildContext context,
    String title,
    String emoji,
    String description,
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
              Text(
                emoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
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
              IconButton(
                icon: Icon(
                  Icons.help_outline,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _showHelp(context, title, emoji, description, value),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontFamily: AppFonts.fontBody,
              fontSize: 11,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
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

  void _showHelp(BuildContext context, String title, String emoji, String description, double value) {
    final helpTexts = _getDetailedHelp(title);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'O que significa?',
                  style: TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  helpTexts['meaning']!,
                  style: TextStyle(
                    fontFamily: AppFonts.fontBody,
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Exemplo:',
                  style: TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  helpTexts['example']!,
                  style: TextStyle(
                    fontFamily: AppFonts.fontBody,
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Entendi',
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, String> _getDetailedHelp(String title) {
    switch (title) {
      case 'Receita Bruta':
        return {
          'meaning': 'É o total de todos os ingressos recebidos, sem nenhum tipo de desconto ou dedução. Inclui dízimos, ofertas, doações e qualquer outra entrada de dinheiro.',
          'example': 'Se a igreja recebeu R\$ 3.117,05 no mês, essa é sua receita bruta.',
        };
      case 'Receita Líquida':
        return {
          'meaning': 'É a receita bruta menos qualquer devolução ou ajuste (por exemplo, devoluções, descontos, ou correções). Na maioria das igrejas, normalmente será igual à receita bruta.',
          'example': 'Se não houve devoluções nem ajustes, Receita líquida = Receita bruta = R\$ 3.117,05',
        };
      case 'Custos Diretos':
        return {
          'meaning': 'São os gastos diretamente relacionados com a entrega de atividades ou projetos. Por exemplo: compra de alimentos para eventos, materiais para um retiro ou pagamento pontual a músicos.',
          'example': 'Se gastou R\$ 0 neste tipo de custos durante o mês, então custos diretos = 0.',
        };
      case 'Resultado Bruto':
        return {
          'meaning': 'É a receita líquida menos os custos diretos. Mostra quanto sobra depois de cobrir os custos diretamente associados à operação ministerial.',
          'example': 'R\$ 3.117,05 – R\$ 0 = R\$ 3.117,05',
        };
      case 'Despesas Operacionais':
        return {
          'meaning': 'São os gastos necessários para manter as atividades diárias da igreja. Inclui: energia, água, limpeza, salários, manutenção, transporte, etc.',
          'example': 'Se a igreja pagou R\$ 101,50 de energia elétrica, despesas operacionais = R\$ 101,50',
        };
      case 'Resultado Operacional':
        return {
          'meaning': 'É o resultado bruto menos as despesas operacionais. Indica se as atividades regulares da igreja estão deixando superávit ou déficit.',
          'example': 'R\$ 3.117,05 – R\$ 101,50 = R\$ 3.015,55',
        };
      case 'Resultados Extraordinários':
        return {
          'meaning': 'São ingressos ou gastos que não fazem parte da rotina diária da igreja, como: venda de equipamentos antigos, reembolsos de seguros, indenizações ou ingressos eventuais. Normalmente será 0, a menos que haja um evento não habitual.',
          'example': 'Se não houve ingressos ou gastos extraordinários no período, o valor é R\$ 0.',
        };
      case 'Resultado Líquido':
        return {
          'meaning': 'É o resultado final do mês ou ano, depois de somar ou subtrair os resultados extraordinários. Mostra se a igreja teve superávit (saldo positivo) ou déficit (saldo negativo) no período.',
          'example': 'R\$ 3.015,55 + R\$ 0 = R\$ 3.015,55 (Superávit)',
        };
      default:
        return {
          'meaning': 'Informação não disponível.',
          'example': 'Consulte o manual.',
        };
    }
  }
}
