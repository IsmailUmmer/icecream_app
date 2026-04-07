import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/invoice.dart';

class QrService {
  static Widget getInvoiceQr(InvoiceModel invoice, {double size = 150}) {
    // Basic compliance string: Seller, Date, Total, Tax
    // For ZATCA (Saudi) it usually requires Base64 encoded TLV, 
    // but for this generic app, we'll start with a clean data string.
    final data = 'Inv: ${invoice.invNo}\n'
        'Client: ${invoice.clientName}\n'
        'Amount: ${invoice.amount}\n'
        'Date: ${invoice.date}';
        
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF34A853)),
      dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Color(0xFF34A853)),
    );
  }
}
