import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import '../../../features/customers/data/models/customer_model.dart';
import '../../../features/suppliers/data/models/supplier_model.dart';
import '../../../features/transactions/data/models/transaction_model.dart';
import '../../extentions/date_extensions.dart';
import 'transaction_pdf_generator.dart';

class TransactionPdfService {
  static String get _exeDir => p.dirname(Platform.resolvedExecutable);

  static String _buildTransactionPdfPath(String customerName) {
    final safeName =
        customerName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
    final timestamp = DateTime.now().shortenFormattedPdfDate;
    return p.join(_exeDir, 'transactions', '${safeName}_$timestamp.pdf');
  }

  static Future<String> saveTransactionsPdf({
    required List<TransactionModel> transactions,
    CustomerModel? customer,
    SupplierModel? supplier,
    String? initialName,
    required String totalAmount,
    String? logoAssetPath,
  }) async {
    Uint8List? logoBytes;
    if (logoAssetPath != null) {
      final data = await rootBundle.load(logoAssetPath);
      logoBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    }

    final fontData = await rootBundle.load('assets/fonts/NotoSansArabic.ttf');

    final Uint8List pdfBytes = await compute(
      generateTransactionPdf,
      TransactionPdfPayload(
        transactions: transactions,
        customer: customer,
        supplier: supplier,
        logoBytes: logoBytes,
        fontBytes: fontData.buffer.asUint8List(fontData.offsetInBytes, fontData.lengthInBytes),
        totalAmount: totalAmount,
      ),
    );
    final name =
        customer != null
            ? customer.name
            : supplier != null
            ? supplier.name
            : '';

    final filePath = _buildTransactionPdfPath(name);
    final dir = Directory(p.dirname(filePath));
    if (!dir.existsSync()) dir.createSync(recursive: true);

    await File(filePath).writeAsBytes(pdfBytes);
    return filePath;
  }
}
