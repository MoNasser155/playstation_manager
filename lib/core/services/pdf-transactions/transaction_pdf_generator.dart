import 'dart:typed_data';

import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:local_erp_system/core/extentions/date_extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../enums/user_type.dart';
import '../../../features/customers/data/models/customer_model.dart';
import '../../../features/suppliers/data/models/supplier_model.dart';
import '../../../features/transactions/data/models/transaction_model.dart';

// const _transactionTypeLabels = {
//   TransactionType.invoiceProfit: 'ربح فاتورة',
//   TransactionType.customerPayment: 'دفعة عميل',
//   TransactionType.supplierPurchase: 'مشتريات مورد',
//   TransactionType.supplierPayment: 'دفعة مورد',
// };

const _userTypeLabels = {UserType.customer: 'عميل', UserType.supplier: 'مورد'};

// String _txTypeAr(TransactionType type) =>
//     _transactionTypeLabels[type] ?? type.name;
String _userTypeAr(UserType type) => _userTypeLabels[type] ?? type.name;

// ─── Payload ───────────────────────────────────────────────────────────────

class TransactionPdfPayload {
  final List<TransactionModel> transactions;
  final CustomerModel? customer;
  final SupplierModel? supplier;
  final String? initialName;
  final Uint8List? logoBytes;
  final Uint8List fontBytes;
  final String totalAmount;

  const TransactionPdfPayload({
    required this.transactions,
    this.customer,
    this.supplier,
    this.initialName,
    this.logoBytes,
    required this.fontBytes,
    required this.totalAmount,
  });
}

// ─── Entry point (top-level for compute()) ─────────────────────────────────

Future<Uint8List> generateTransactionPdf(TransactionPdfPayload payload) async {
  final font = pw.Font.ttf(payload.fontBytes.buffer.asByteData());

  final reshaper = ArabicReshaper();
  String ar(String text) => reshaper.reshape(text);

  final pdf = pw.Document();

  pw.ImageProvider? logo;
  if (payload.logoBytes != null) {
    logo = pw.MemoryImage(payload.logoBytes!);
  }

  final name =
      payload.customer != null
          ? payload.customer?.name
          : payload.supplier != null
          ? payload.supplier?.name
          : '';
  final address =
      payload.customer != null
          ? payload.customer?.address
          : payload.supplier != null
          ? payload.supplier?.address
          : '';
  final phone =
      payload.customer != null
          ? payload.customer?.phone1
          : payload.supplier != null
          ? payload.supplier?.phone1
          : '';

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      header: (context) {
        if (context.pageNumber > 1) {
          return pw.SizedBox();
        }
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            children: [
              _buildHeader(
                name ?? '',
                address,
                phone,
                payload.totalAmount,
                logo,
                font,
                ar,
              ),
              pw.SizedBox(height: 12),
            ],
          ),
        );
      },
      footer:
          (context) => pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Divider(color: PdfColors.blueGrey100, thickness: 0.5),
                pw.SizedBox(height: 4),
                _buildFooter(context, font, ar),
              ],
            ),
          ),
      build:
          (context) => [
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: _buildTable(payload.transactions, font, ar),
            ),
          ],
    ),
  );

  return pdf.save();
}

// ─── Header ────────────────────────────────────────────────────────────────

pw.Widget _buildHeader(
  String customerName,
  String? address,
  String? phone,
  String totalAmount,
  pw.ImageProvider? logo,
  pw.Font font,
  String Function(String) ar,
) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        flex: 4,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              ar('العميل: $customerName'),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font,
                fontSize: 11,
                color: PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              ar('العنوان: $address'),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font,
                fontSize: 11,
                color: PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              ar('الهاتف: $phone'),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font,
                fontSize: 11,
                color: PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              ar('الإجمالي: $totalAmount'),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font,
                fontSize: 11,
                color: PdfColors.black,
              ),
            ),
            pw.Text(
              ar('تاريخ الإنشاء: ${DateTime.now().toFullArabicFormattedDate}'),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font,
                fontSize: 9,
                color: PdfColors.blueGrey400,
              ),
            ),
          ],
        ),
      ),
      pw.SizedBox(width: 80),
      pw.Expanded(
        flex: 3,
        child:
            logo != null
                ? pw.Image(
                  logo,
                  width: 120,
                  height: 120,
                  fit: pw.BoxFit.contain,
                )
                : pw.SizedBox(),
      ),
      pw.SizedBox(width: 80),
      pw.Expanded(
        flex: 3,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              ar('البدري للخيوط ومستلزمات التطريز'),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font,
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              ar('شبرا ملكان - مركز المحلة الكبرى'),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font,
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              ar('01065673083'),
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font,
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// ─── Table ─────────────────────────────────────────────────────────────────

pw.Widget _buildTable(
  List<TransactionModel> rows,
  pw.Font font,
  String Function(String) ar,
) {
  final headerStyle = pw.TextStyle(
    font: font,
    color: PdfColors.white,
    fontSize: 10,
    fontWeight: pw.FontWeight.bold,
  );
  final cellStyle = pw.TextStyle(font: font, fontSize: 8);

  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.blueGrey100, width: 0.5),
    columnWidths: {
      0: const pw.FlexColumnWidth(2),
      1: const pw.FlexColumnWidth(1.2),
      2: const pw.FlexColumnWidth(1.5),
      3: const pw.FlexColumnWidth(1.5),
      4: const pw.FlexColumnWidth(1.5),
      5: const pw.FlexColumnWidth(1.5),
      6: const pw.FlexColumnWidth(4),
    },
    children: [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.blue700),
        children:
            [
              ar('التاريخ'),
              ar('نوع المستخدم'),
              ar('الرصيد النهائي'),
              ar('المدفوع'),
              ar('الإجمالي'),
              ar('الرصيد الابتدائي'),
              ar('ملاحظات'),
            ].map((h) => _cell(h, style: headerStyle, center: true)).toList(),
      ),
      ...rows.asMap().entries.map((e) {
        final tx = e.value;
        final bg = e.key.isOdd ? PdfColors.blueGrey50 : PdfColors.white;
        return pw.TableRow(
          decoration: pw.BoxDecoration(color: bg),
          children: [
            _cell(tx.createdAt.shortenFormattedDate, style: cellStyle),
            _cell(ar(_userTypeAr(tx.userTypeVal)), style: cellStyle),
            _cell(_amt(tx.endBalance), style: cellStyle),
            _cell(_amt(tx.paidInvoiceAmount), style: cellStyle),
            _cell(_amt(tx.paymentAmount), style: cellStyle),
            _cell(_amt(tx.beginningBalance), style: cellStyle),
            _cell(ar(tx.notes ?? 'لا يوجد'), style: cellStyle),
          ],
        );
      }),
    ],
  );
}

pw.Widget _cell(
  String text, {
  required pw.TextStyle style,
  bool center = false,
}) => pw.Padding(
  padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
  child: pw.Text(
    text,
    textDirection: pw.TextDirection.rtl,
    style: style,
    textAlign: center ? pw.TextAlign.center : pw.TextAlign.right,
  ),
);

// ─── Footer ────────────────────────────────────────────────────────────────

pw.Widget _buildFooter(
  pw.Context ctx,
  pw.Font font,
  String Function(String) ar,
) => pw.Row(
  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  children: [
    pw.Spacer(),
    pw.Text(
      ar('صفحة ${ctx.pageNumber} / ${ctx.pagesCount}'),
      textDirection: pw.TextDirection.rtl,
      style: pw.TextStyle(font: font, fontSize: 7, color: PdfColors.grey),
    ),
  ],
);

// ─── Helpers ───────────────────────────────────────────────────────────────

String _amt(double? v) => v == null ? 'لا يوجد' : v.toStringAsFixed(2);
