import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/features/erp/contributions/models/contribution_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/contribution.helper.dart';
import '../../../store/contribution_pagination_store.dart';
import 'view_contribution.dart';

class ContributionTable extends StatefulWidget {
  const ContributionTable({super.key});

  @override
  State<ContributionTable> createState() => _ContributionTableState();
}

class _ContributionTableState extends State<ContributionTable> {
  @override
  Widget build(BuildContext context) {
    final contributionPaginationStore =
        Provider.of<ContributionPaginationStore>(context);

    final state = contributionPaginationStore.state;

    if (state.paginate.results.isEmpty) {
      return Center(child: Text('Nenhuma contribuição encontrada'));
    }

    return Container(
      margin: isMobile(context) ? null : const EdgeInsets.only(top: 40.0),
      child: CustomTable(
        headers: ["Nome", "Valor", "Tipo de contribuçāo", "Status", "Fecha"],
        data: FactoryDataTable<ContributionModel>(
          data: state.paginate.results,
          dataBuilder: contributionDTO,
        ),
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
          },
        ),
        actionBuilders: [
          (contribution) => ButtonActionTable(
            color: AppColors.blue,
            text: "Visualizar",
            onPressed: () {
              _openModal(context, contribution);
            },
            icon: Icons.remove_red_eye_sharp,
          ),
        ],
      ),
    );
  }

  void _openModal(BuildContext context, ContributionModel contribution) {
    ModalPage(
      title:
          isMobile(context)
              ? ""
              : 'Contribuição #${contribution.contributionId}',
      body: ViewContribution(
        contribution: contribution,
        contributionPaginationStore:
            context.read<ContributionPaginationStore>(),
      ),
    ).show(context);
  }

  List<dynamic> contributionDTO(dynamic contribution) {
    final status = parseContributionStatus(contribution.status);

    return [
      contribution.member.name,
      CurrencyFormatter.formatCurrency(
        contribution.amount,
        symbol: contribution.account.symbol,
      ),
      contribution.financeConcept.name,
      tagStatus(getContributionStatusColor(status), status.friendlyName),
      convertDateFormatToDDMMYYYY(contribution.createdAt.toString()),
    ];
  }
}
