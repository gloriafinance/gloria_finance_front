import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../store/form_supplier_store.dart';
import 'layouts/form_supplier_desktop_layout.dart';
import 'layouts/form_supplier_mobile_layout.dart';

class FormSupplier extends StatefulWidget {
  const FormSupplier({super.key});

  @override
  State<StatefulWidget> createState() => _FormSupplierState();
}

class _FormSupplierState extends State<FormSupplier> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormSupplierStore>(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            isMobile(context)
                ? formSupplierMobileLayout(context, formStore)
                : formSupplierDesktopLayout(context, formStore),
            const SizedBox(height: 32),
            isMobile(context)
                ? _btnSave(formStore)
                : Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(width: 300, child: _btnSave(formStore)),
                ),
          ],
        ),
      ),
    );
  }

  Widget _btnSave(FormSupplierStore formStore) {
    return (formStore.state.makeRequest)
        ? const Loading()
        : Padding(
          padding: EdgeInsets.only(top: 20),
          child: CustomButton(
            text: "Salvar",
            backgroundColor: AppColors.green,
            textColor: Colors.black,
            onPressed: () => _saveRecord(formStore),
          ),
        );
  }

  void _saveRecord(FormSupplierStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    var response = await formStore.save();
    if (response) {
      Toast.showMessage("Fornecedor registrado com sucesso", ToastType.info);
      GoRouter.of(context).go('/suppliers');
    } else {
      Toast.showMessage("Erro ao registrar fornecedor", ToastType.error);
    }
  }
}
