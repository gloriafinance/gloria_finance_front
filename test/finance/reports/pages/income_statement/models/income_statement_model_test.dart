// test/finance/reports/pages/income_statement/models/income_statement_model_test.dart

import 'package:church_finance_bk/finance/reports/pages/income_statement/models/income_statement_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('IncomeStatementCategory', () {
    test('incomeStatementCategoryFromApi maps all API categories correctly', () {
      expect(
        incomeStatementCategoryFromApi('REVENUE'),
        equals(IncomeStatementCategory.revenue),
      );
      expect(
        incomeStatementCategoryFromApi('COGS'),
        equals(IncomeStatementCategory.cogs),
      );
      expect(
        incomeStatementCategoryFromApi('OPEX'),
        equals(IncomeStatementCategory.opex),
      );
      expect(
        incomeStatementCategoryFromApi('CAPEX'),
        equals(IncomeStatementCategory.capex),
      );
      expect(
        incomeStatementCategoryFromApi('MINISTRY_TRANSFERS'),
        equals(IncomeStatementCategory.ministryTransfers),
      );
      expect(
        incomeStatementCategoryFromApi('OTHER'),
        equals(IncomeStatementCategory.other),
      );
    });

    test('incomeStatementCategoryFromApi handles case insensitivity', () {
      expect(
        incomeStatementCategoryFromApi('ministry_transfers'),
        equals(IncomeStatementCategory.ministryTransfers),
      );
      expect(
        incomeStatementCategoryFromApi('Ministry_Transfers'),
        equals(IncomeStatementCategory.ministryTransfers),
      );
      expect(
        incomeStatementCategoryFromApi('revenue'),
        equals(IncomeStatementCategory.revenue),
      );
    });

    test('incomeStatementCategoryFromApi returns unknown for invalid values', () {
      expect(
        incomeStatementCategoryFromApi('INVALID'),
        equals(IncomeStatementCategory.unknown),
      );
      expect(
        incomeStatementCategoryFromApi(null),
        equals(IncomeStatementCategory.unknown),
      );
      expect(
        incomeStatementCategoryFromApi(''),
        equals(IncomeStatementCategory.unknown),
      );
    });

    test('friendlyName extension returns correct Portuguese names', () {
      expect(
        IncomeStatementCategory.revenue.friendlyName,
        equals('Receitas'),
      );
      expect(
        IncomeStatementCategory.cogs.friendlyName,
        equals('Custos Diretos'),
      );
      expect(
        IncomeStatementCategory.opex.friendlyName,
        equals('Despesas Operacionais'),
      );
      expect(
        IncomeStatementCategory.capex.friendlyName,
        equals('Investimentos de Capital'),
      );
      expect(
        IncomeStatementCategory.ministryTransfers.friendlyName,
        equals('Repasses Ministeriais'),
      );
      expect(
        IncomeStatementCategory.other.friendlyName,
        equals('Outras Receitas/Despesas'),
      );
      expect(
        IncomeStatementCategory.unknown.friendlyName,
        equals('Categoria'),
      );
    });

    test('description extension returns correct descriptions', () {
      expect(
        IncomeStatementCategory.revenue.description,
        equals('Entradas operacionais e doações recorrentes.'),
      );
      expect(
        IncomeStatementCategory.cogs.description,
        equals('Custos diretos para entregar serviços ou projetos.'),
      );
      expect(
        IncomeStatementCategory.opex.description,
        equals('Despesas necessárias para manter a igreja ativa.'),
      );
      expect(
        IncomeStatementCategory.capex.description,
        equals('Investimentos e gastos de capital de longo prazo.'),
      );
      expect(
        IncomeStatementCategory.ministryTransfers.description,
        equals('Repasses e contribuições ministeriais.'),
      );
      expect(
        IncomeStatementCategory.other.description,
        equals('Receitas ou despesas extraordinárias.'),
      );
      expect(
        IncomeStatementCategory.unknown.description,
        equals(''),
      );
    });

    test('accentColor extension returns valid Color objects', () {
      expect(
        IncomeStatementCategory.revenue.accentColor,
        equals(const Color(0xFF1B998B)),
      );
      expect(
        IncomeStatementCategory.cogs.accentColor,
        equals(const Color(0xFF8ECAE6)),
      );
      expect(
        IncomeStatementCategory.opex.accentColor,
        equals(const Color(0xFFD62839)),
      );
      expect(
        IncomeStatementCategory.capex.accentColor,
        equals(const Color(0xFFFB8500)),
      );
      expect(
        IncomeStatementCategory.ministryTransfers.accentColor,
        equals(const Color(0xFF9B59B6)),
      );
      expect(
        IncomeStatementCategory.other.accentColor,
        equals(const Color(0xFF6A4C93)),
      );
      expect(
        IncomeStatementCategory.unknown.accentColor,
        equals(const Color(0xFFADB5BD)),
      );
    });
  });

  group('IncomeStatementBreakdown', () {
    test('fromJson parses ministry transfers category correctly', () {
      final json = {
        'category': 'MINISTRY_TRANSFERS',
        'income': 0,
        'expenses': 101.5,
        'net': -101.5,
      };

      final breakdown = IncomeStatementBreakdown.fromJson(json);

      expect(breakdown.category, equals(IncomeStatementCategory.ministryTransfers));
      expect(breakdown.income, equals(0.0));
      expect(breakdown.expenses, equals(101.5));
      expect(breakdown.net, equals(-101.5));
    });

    test('fromJson parses all categories from API response', () {
      final breakdownData = [
        {
          'category': 'REVENUE',
          'income': 3587.05,
          'expenses': 0,
          'net': 3587.05,
        },
        {
          'category': 'COGS',
          'income': 0,
          'expenses': 0,
          'net': 0,
        },
        {
          'category': 'OPEX',
          'income': 0,
          'expenses': 1829.57,
          'net': -1829.57,
        },
        {
          'category': 'MINISTRY_TRANSFERS',
          'income': 0,
          'expenses': 101.5,
          'net': -101.5,
        },
        {
          'category': 'CAPEX',
          'income': 0,
          'expenses': 0,
          'net': 0,
        },
        {
          'category': 'OTHER',
          'income': 0,
          'expenses': 0,
          'net': 0,
        },
      ];

      final breakdowns = breakdownData
          .map((item) => IncomeStatementBreakdown.fromJson(item))
          .toList();

      expect(breakdowns.length, equals(6));
      expect(breakdowns[0].category, equals(IncomeStatementCategory.revenue));
      expect(breakdowns[1].category, equals(IncomeStatementCategory.cogs));
      expect(breakdowns[2].category, equals(IncomeStatementCategory.opex));
      expect(breakdowns[3].category, equals(IncomeStatementCategory.ministryTransfers));
      expect(breakdowns[4].category, equals(IncomeStatementCategory.capex));
      expect(breakdowns[5].category, equals(IncomeStatementCategory.other));
    });

    test('fromJson handles numeric values as int or double', () {
      final json = {
        'category': 'MINISTRY_TRANSFERS',
        'income': 100,
        'expenses': 50.75,
        'net': 49.25,
      };

      final breakdown = IncomeStatementBreakdown.fromJson(json);

      expect(breakdown.income, equals(100.0));
      expect(breakdown.expenses, equals(50.75));
      expect(breakdown.net, equals(49.25));
    });
  });

  group('IncomeStatementModel', () {
    test('fromJson parses complete API response with MINISTRY_TRANSFERS', () {
      final json = {
        'period': {
          'year': '2025',
          'month': '11',
        },
        'breakdown': [
          {
            'category': 'REVENUE',
            'income': 3587.05,
            'expenses': 0,
            'net': 3587.05,
          },
          {
            'category': 'MINISTRY_TRANSFERS',
            'income': 0,
            'expenses': 101.5,
            'net': -101.5,
          },
        ],
        'summary': {
          'revenue': 3587.05,
          'cogs': 0,
          'grossProfit': 1655.98,
          'operatingExpenses': 1931.07,
          'operatingIncome': 1655.98,
          'capitalExpenditures': 0,
          'otherIncome': 0,
          'otherExpenses': 0,
          'otherNet': 0,
          'netIncome': 1655.98,
        },
        'cashFlowSnapshot': {
          'availabilityAccounts': {
            'accounts': [],
            'total': 0,
            'income': 0,
            'expenses': 0,
          },
          'costCenters': {
            'costCenters': [],
            'total': 0,
          },
        },
      };

      final model = IncomeStatementModel.fromJson(json);

      expect(model.period.year, equals(2025));
      expect(model.period.month, equals(11));
      expect(model.breakdown.length, equals(2));
      expect(model.breakdown[1].category, equals(IncomeStatementCategory.ministryTransfers));
      expect(model.breakdown[1].expenses, equals(101.5));
      expect(model.breakdown[1].net, equals(-101.5));
    });

    test('empty factory creates model with empty breakdown list', () {
      final model = IncomeStatementModel.empty();

      expect(model.breakdown, isEmpty);
      expect(model.period.year, equals(0));
      expect(model.period.month, equals(0));
    });
  });
}
