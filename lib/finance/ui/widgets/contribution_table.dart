import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';
import 'package:church_finance_bk/finance/providers/contributions_provider.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view_contribution.dart';

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
        data: (data) =>
            buildTable(data.results, data.nextPag, data.count, data.perPage),
        error: (error, _) => Text("Error: $error"),
        loading: () => CircularProgressIndicator());
  }

  Widget buildTable(
      List<Contribution> data, bool nextPage, int totalRecord, int perPage) {
    return CustomTable(
      headers: ["Nome", "Valor", "Tipo de contribuçāo", "Status", "Fecha"],
      data: FactoryDataTable<Contribution>(
          data: data, dataBuilder: contributionDTO),
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
            ref.read(contributionsFilterProvider.notifier).setPerPage(perPage);
          }),
      actionBuilders: [
        (contribution) => ButtonActionTable(
              color: AppColors.blue,
              text: "Visualizar",
              onPressed: () {
                print("Aprobar fila $contribution");
                _openModal(contribution);
              },
              icon: Icons.remove_red_eye_sharp,
            ),
      ],
    );
  }

  void _openModal(Contribution contribution) {
    ModalPage(
      title: 'Contribuição #${contribution.contributionId}',
      body: ViewContribution(contribution: contribution),
    ).show(context);
  }

  List<dynamic> contributionDTO(dynamic contribution) {
    return [
      contribution.member.name,
      formatCurrency(contribution.amount),
      contribution.financeConcept.name,
      ContributionStatus.values
          .firstWhere(
              (e) => e.toString().split('.').last == contribution.status)
          .friendlyName,
      contribution.createdAt.toString(),
    ];
  }
}
