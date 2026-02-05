import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/index.dart';
import 'package:gloria_finance/features/erp/contributions/models/contribution_model.dart';
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
      return Center(
        child: Text(context.l10n.contributions_table_empty),
      );
    }

    return Container(
      margin: isMobile(context) ? null : const EdgeInsets.only(top: 40.0),
      child: CustomTable(
        headers: [
          context.l10n.contributions_table_header_member,
          context.l10n.contributions_table_header_amount,
          context.l10n.contributions_table_header_type,
          context.l10n.contributions_table_header_status,
          context.l10n.contributions_table_header_date,
        ],
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
            text: context.l10n.common_view,
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
              : context.l10n.contributions_table_modal_title(
                  contribution.contributionId,
                ),
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
      tagStatus(
        getContributionStatusColor(status),
        getContributionStatusLabel(context, status),
      ),
      convertDateFormatToDDMMYYYY(contribution.createdAt.toString()),
    ];
  }
}
