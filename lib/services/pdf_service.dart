import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/invoice.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';

class PdfService {
  static Future<void> generateInvoicePdf(InvoiceModel invoice) async {
    final pdf = await _generateDocument(invoice);
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static Future<void> shareInvoicePdf(InvoiceModel invoice) async {
    final pdf = await _generateDocument(invoice);
    final bytes = await pdf.save();
    await Share.shareXFiles(
      [XFile.fromData(bytes, name: 'invoice_${invoice.invNo}.pdf', mimeType: 'application/pdf')],
      text: 'Invoice ${invoice.invNo} for ${invoice.clientName}',
    );
  }

  static Future<pw.Document> _generateDocument(InvoiceModel invoice) async {
    final pdf = pw.Document();
    final currency = invoice.currency;
    
    // Load font that supports Rupee symbol
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();
    final theme = pw.ThemeData.withFont(
      base: font,
      bold: boldFont,
    );

    pdf.addPage(
      pw.Page(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('E-INVOICE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
                  pw.Text(invoice.invNo, style: const pw.TextStyle(fontSize: 14)),
                ],
              ),
              pw.SizedBox(height: 20),
              _buildHeader(invoice),
              pw.SizedBox(height: 30),
              _buildTable(invoice, currency),
              pw.SizedBox(height: 20),
              _buildSummary(invoice, currency),
              pw.Spacer(),
              pw.Divider(),
              pw.Text('Thank you for your business!', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  static pw.Widget _buildHeader(InvoiceModel invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Billing to:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(invoice.clientName),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Date: ${invoice.date}'),
            pw.Text('Due: ${invoice.dueDate}'),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTable(InvoiceModel invoice, String currency) {
    final headers = ['Description', 'Quantity', 'Price', 'Total'];
    final data = invoice.items.map((item) => [
      item.name,
      item.quantity.toString(),
      '$currency${item.price.toStringAsFixed(2)}',
      '$currency${item.total.toStringAsFixed(2)}'
    ]).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.green),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildSummary(InvoiceModel invoice, String currency) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text('Total: $currency${invoice.amount.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
          pw.SizedBox(height: 4),
          pw.Text('Due: $currency${invoice.dueAmount.toStringAsFixed(2)}', style: pw.TextStyle(color: PdfColors.red)),
        ],
      ),
    );
  }
}
