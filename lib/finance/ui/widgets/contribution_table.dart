import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';
import 'package:church_finance_bk/finance/providers/contributions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContributionTable extends ConsumerStatefulWidget {
  const ContributionTable({super.key});

  @override
  ConsumerState<ContributionTable> createState() => _ContributionTableState();
}

class _ContributionTableState extends ConsumerState<ContributionTable> {
  @override
  Widget build(BuildContext context) {
    final contributionsAsync = ref.watch(searchContributionsProvider);

    return contributionsAsync.when(
        data: (data) => buildTable(contributionDTO(data.results), data.nextPag,
            data.count, data.perPage),
        error: (error, _) => Text("Error: $error"),
        loading: () => CircularProgressIndicator());
  }

  Widget buildTable(
      List<List<String>> data, bool nextPage, int totalRecord, int perPage) {
    return CustomTable(
      headers: ["Nome", "Valor", "Tipo de contribuçāo", "Fecha"],
      data: data,
      paginate: PaginationData(
          totalRecords: totalRecord,
          nextPag: nextPage,
          perPage: perPage,
          currentPage: ref.watch(contributionsFilterProvider).page,
          onNextPag: () {
            ref.read(contributionsFilterProvider.notifier).nextPage();
          },
          onPrevPag: () {
            ref.read(contributionsFilterProvider.notifier).prevPage();
          },
          onChangePerPage: (perPage) {
            // ref
            //     .read(contributionsPaginationProvider.notifier)
            //     .setPerPage(perPage);
            ref.read(contributionsFilterProvider.notifier).setPerPage(perPage);
          }),
      actionBuilders: [
        (rowIndex) => IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                print("Editar fila $rowIndex");
              },
            ),
        (rowIndex) => IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                print("Eliminar fila $rowIndex");
              },
            ),
      ],
    );
  }

  List<List<String>> contributionDTO(List<Contribution> results) {
    return results
        .map((contribution) => [
              contribution.member.name,
              "\$${contribution.amount.toStringAsFixed(2)}",
              contribution.financeConcept.name,
              contribution.createdAt.toString(),
            ])
        .toList();
  }
}
