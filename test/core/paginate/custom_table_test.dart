import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTable pagination', () {
    testWidgets('includes the active perPage value among dropdown options',
        (tester) async {
      final pagination = PaginationData(
        totalRecords: 1,
        nextPag: false,
        perPage: 10,
        currentPage: 1,
        onNextPag: () {},
        onPrevPag: () {},
        onChangePerPage: (_) {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTable(
              headers: const ['Col'],
              data: FactoryDataTable(
                data: const [1],
                dataBuilder: _buildRow,
              ),
              paginate: pagination,
            ),
          ),
        ),
      );

      final dropdown = tester.widget<DropdownButton<int>>(
        find.byType(DropdownButton<int>).first,
      );

      final optionValues = dropdown.items?.map((item) => item.value).toList();

      expect(optionValues, contains(pagination.perPage));
    });
  });
}

List<dynamic> _buildRow(dynamic item) {
  return const [Text('value')];
}
