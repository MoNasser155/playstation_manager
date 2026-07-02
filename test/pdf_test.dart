import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_erp_system/core/enums/transaction_type.dart';
import 'package:local_erp_system/core/enums/user_type.dart';
import 'package:local_erp_system/core/services/pdf-transactions/transaction_pdf_generator.dart';
import 'package:local_erp_system/features/transactions/data/models/transaction_model.dart';

void main() {
  test('generate PDF with more than 18 transactions', () async {
    final fontFile = File('assets/fonts/NotoSansArabic.ttf');
    final fontBytes = fontFile.readAsBytesSync();

    final logoFile = File(
      'assets/images/logo.png',
    ); // Wait, let's check if logo exists, or use empty/null bytes
    final logoBytes =
        logoFile.existsSync() ? logoFile.readAsBytesSync() : Uint8List(0);

    final transactions = List.generate(
      50,
      (index) => TransactionModel.create(
        uuid: 'tx-$index',
        userUuid: 'user-1',
        userName: 'Test User',
        beginningBalance: 100.0,
        paymentAmount: 50.0,
        paidInvoiceAmount: 50.0,
        endBalance: 100.0,
        transactionType: TransactionType.customerPayment,
        userType: UserType.customer,
        createdAt: DateTime.now(),
        notes: index % 3 == 0 
            ? 'This is a very long note that will definitely wrap to multiple lines in the table cell to test if it overflows the page limit.' 
            : 'Note $index',
      ),
    );

    final payload = TransactionPdfPayload(
      transactions: transactions,
      initialName: 'Test File',
      fontBytes: fontBytes,
      totalAmount: '1250.00',
      logoBytes: logoBytes.isNotEmpty ? logoBytes : null,
    );

    try {
      final pdfBytes = await generateTransactionPdf(payload);
      log('PDF generated successfully, bytes length: ${pdfBytes.length}');
      expect(pdfBytes, isNotEmpty);
    } catch (e, stack) {
      log('Error generating PDF: $e');
      log(stack.toString());
      rethrow;
    }
  });
}
