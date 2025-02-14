import 'package:church_finance_bk/core/layout/view_detail_widgets.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/finance/purchase/pages/purchases/models/purchase_list_model.dart';
import 'package:church_finance_bk/finance/widgets/content_viewer.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';

class ViewPurchase extends StatelessWidget {
  final PurchaseListModel purchase;

  const ViewPurchase({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    bool mobile = isMobile(context);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle('Detalhes da compra'),
            const Divider(),
            SizedBox(height: 16),
            buildDetailRow(mobile, 'Data',
                convertDateFormatToDDMMYYYY(purchase.purchaseDate)),
            buildDetailRow(mobile, 'Descrição', purchase.description),
            buildDetailRow(mobile, 'Imposto', formatCurrency(purchase.tax)),
            buildDetailRow(mobile, 'Valor', formatCurrency(purchase.total)),
            SizedBox(height: 26),
            _tableItems(purchase.items),
            const SizedBox(height: 26),
            buildSectionTitle('Fatura'),
            //const SizedBox(height: 26),
            ContentViewer(url: purchase.invoice),
          ],
        ),
      ),
    );
  }

  Widget _tableItems(List<PurchaseItemModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Itens da compra'),
        SizedBox(height: 16),
        Table(
          border: TableBorder.all(color: Colors.grey),
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Produto',
                        style: TextStyle(fontFamily: AppFonts.fontTitle)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Quantidade',
                        style: TextStyle(fontFamily: AppFonts.fontTitle)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Valor unitário',
                        style: TextStyle(fontFamily: AppFonts.fontTitle)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Valor total',
                        style: TextStyle(fontFamily: AppFonts.fontTitle)),
                  ),
                ),
              ],
            ),
            ...items.map((item) {
              return TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.name,
                          style: TextStyle(fontFamily: AppFonts.fontText)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(formatCurrency(item.price),
                          style: TextStyle(fontFamily: AppFonts.fontText)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.quantity.toString(),
                          style: TextStyle(fontFamily: AppFonts.fontText)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(formatCurrency(item.total),
                          style: TextStyle(fontFamily: AppFonts.fontText)),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }
}
