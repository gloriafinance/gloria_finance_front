import 'package:church_finance_bk/core/widgets/custom_table.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(contributionServiceProvider.notifier)
            .searchContributions(ref.watch(contributionsFilterProvider));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final contributionsAsync = ref.watch(contributionServiceProvider);

    final data = contribuutionDTO(contributionsAsync.results);

    return CustomTable(
      headers: ["Nombre", "Monto", "Tipo de contribuçāo", "Fecha"],
      data: data,
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

  List<List<String>> contribuutionDTO(List<Contribution> results) {
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
