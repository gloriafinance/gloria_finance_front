import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/form_supplier_store.dart';
import 'widgets/form_supplier.dart';

class RegisterSupplierScreen extends StatelessWidget {
  const RegisterSupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return ChangeNotifierProvider(
      create: (_) => FormSupplierStore(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go("/suppliers"),
                child: Icon(Icons.arrow_back_ios, color: AppColors.purple),
              ),
              Text(
                "Registrar Fornecedor",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          FormSupplier(),
        ],
      ),
    );
  }
}
