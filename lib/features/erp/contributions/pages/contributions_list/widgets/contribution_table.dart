import 'package:flutter/material.dart';
import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/index.dart';
import 'package:gloria_finance/features/erp/contributions/models/contribution_model.dart';
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

    if (state.makeRequest) {
      return Container(
        alignment: Alignment.center,
        margin: isMobile(context) ? null : const EdgeInsets.only(top: 40.0),
        child: const CircularProgressIndicator(),
      );
    }

    if (state.paginate.results.isEmpty) {
      return Center(child: Text(context.l10n.contributions_table_empty));
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
            text:
                state.viewContributionLoading
                    ? context.l10n.common_loading
                    : context.l10n.common_view,
            onPressed: () {
              if (!state.viewContributionLoading) {
                _openModal(context, contribution);
              }
            },
            icon:
                state.viewContributionLoading
                    ? Icons.hourglass_bottom
                    : Icons.remove_red_eye_sharp,
          ),
        ],
      ),
    );
  }

  Future<void> _openModal(
    BuildContext context,
    ContributionModel contribution,
  ) async {
    final store = context.read<ContributionPaginationStore>();

    if (store.state.viewContributionLoading) return;

    final fetchedContribution = await store.viewContribution(
      contribution.contributionId,
    );

    if (!context.mounted) return;

    if (fetchedContribution != null) {
      ModalPage(
        title:
            isMobile(context)
                ? ''
                : context.l10n.contributions_table_modal_title(
                  fetchedContribution.contributionId,
                ),
        body: ViewContribution(
          contribution: fetchedContribution,
          contributionPaginationStore: store,
        ),
      ).show(context);
    } else {
      Toast.showMessage(
        context.l10n.contributions_table_error_load_contribution,
        ToastType.error,
      );
    }
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
