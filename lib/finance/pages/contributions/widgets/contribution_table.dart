import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';

import 'contribution_filters.dart';
import 'view_contribution.dart';

class ContributionTable extends StatefulWidget {
  const ContributionTable({super.key});

  @override
  State<ContributionTable> createState() => _ContributionTableState();
}

class _ContributionTableState extends State<ContributionTable> {
  @override
  Widget build(BuildContext context) {
    if (contributionPaginationStore.state.paginate.results.isEmpty) {
      contributionPaginationStore.searchContributions();
    }

    return ListenableBuilder(
        listenable: contributionPaginationStore,
        builder: (context, _) {
          final state = contributionPaginationStore.state;

          if (state.makeRequest) {
            return CircularProgressIndicator();
          }

          if (state.paginate.results.isEmpty) {
            return Center(child: Text('No hay contribuciones para mostrar'));
          }

          return CustomTable(
            headers: [
              "Nome",
              "Valor",
              "Tipo de contribuçāo",
              "Status",
              "Fecha"
            ],
            data: FactoryDataTable<ContributionModel>(
                data: state.paginate.results, dataBuilder: contributionDTO),
            paginate: PaginationData(
                totalRecords: state.paginate.count,
                nextPag: state.paginate.nextPag,
                perPage: state.paginate.perPage,
                currentPage: state.filter.page,
                onNextPag: () {
                  contributionPaginationStore.nextPage();
                },
                onPrevPag: () {
                  contributionPaginationStore.prevPage();
                },
                onChangePerPage: (perPage) {
                  contributionPaginationStore.setPerPage(perPage);
                }),
            actionBuilders: [
              (contribution) => ButtonActionTable(
                    color: AppColors.blue,
                    text: "Visualizar",
                    onPressed: () {
                      print("Aprobar fila $contribution");
                      _openModal(context, contribution);
                    },
                    icon: Icons.remove_red_eye_sharp,
                  ),
            ],
          );
        });
  }

  void _openModal(BuildContext context, ContributionModel contribution) {
    ModalPage(
      title: isMobile(context)
          ? ""
          : 'Contribuição #${contribution.contributionId}',
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
