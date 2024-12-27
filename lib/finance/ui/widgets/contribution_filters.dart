import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/custom_select.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';
import 'package:church_finance_bk/finance/providers/contributions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ContributionFilters extends ConsumerStatefulWidget {
  const ContributionFilters({super.key});

  @override
  ConsumerState<ContributionFilters> createState() =>
      _ContributionFiltersState();
}

class _ContributionFiltersState extends ConsumerState<ContributionFilters> {
  final form = FormGroup({
    'status': FormControl<String>(),
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: form,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: CustomSelect(
                label: "Status",
                formControlName: "status",
                items: ContributionStatus.values
                    .map((e) => e.friendlyName)
                    .toList(),
              ),
            ),

            const SizedBox(width: 10),

            // Separador entre los widgets
            // Uso de Flexible para el botón
            Flexible(
              flex: 1, // Menor peso para que ocupe menos espacio
              child: Padding(
                padding: EdgeInsets.only(top: 54),
                child: CustomButton(
                  text: "Filtrar",
                  backgroundColor: AppColors.purple,
                  width: 100,
                  textColor: Colors.white,
                  onPressed: applyFilter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void applyFilter() {
    print("Aplicando filtro ${form.control('status').value}");
    ref.read(contributionsFilterProvider.notifier).status(
          form.control('status').value,
        );
  }
}
