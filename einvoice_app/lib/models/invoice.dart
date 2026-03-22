import 'dart:convert';

enum InvoiceStatus { paid, unpaid, partiallyPaid }

class InvoiceItemModel {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String description;
  final String category;

  InvoiceItemModel({
    required this.id,
    required this.name,
    this.quantity = 1,
    required this.price,
    this.description = '',
    this.category = 'Services',
  });

  double get total => quantity * price;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'price': price,
        'description': description,
        'category': category,
      };

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      InvoiceItemModel(
        id: json['id'] as String,
        name: json['name'] as String,
        quantity: json['quantity'] as int,
        price: (json['price'] as num).toDouble(),
        description: json['description'] as String? ?? '',
        category: json['category'] as String? ?? 'Services',
      );
}

class Party {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String website;
  final String logo;

  Party({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.city = '',
    this.website = '',
    this.logo = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'city': city,
        'website': website,
        'logo': logo,
      };

  factory Party.fromJson(Map<String, dynamic> json) => Party(
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        address: json['address'] as String? ?? '',
        city: json['city'] as String? ?? '',
        website: json['website'] as String? ?? '',
        logo: json['logo'] as String? ?? '',
      );
}

class InvoiceInfo {
  final String invNo;
  final String date;
  final String dueDate;
  final String currency;

  InvoiceInfo({
    this.invNo = '',
    this.date = '',
    this.dueDate = '',
    this.currency = '\$',
  });

  Map<String, dynamic> toJson() => {
        'invNo': invNo,
        'date': date,
        'dueDate': dueDate,
        'currency': currency,
      };

  factory InvoiceInfo.fromJson(Map<String, dynamic> json) => InvoiceInfo(
        invNo: json['invNo'] as String? ?? '',
        date: json['date'] as String? ?? '',
        dueDate: json['dueDate'] as String? ?? '',
        currency: json['currency'] as String? ?? '\$',
      );
}

class PaymentInfo {
  final String accountName;
  final String accountNo;
  final String bankName;
  final String swift;
  final String method;

  PaymentInfo({
    this.accountName = '',
    this.accountNo = '',
    this.bankName = '',
    this.swift = '',
    this.method = 'PayPal',
  });

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'accountNo': accountNo,
        'bankName': bankName,
        'swift': swift,
        'method': method,
      };

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        accountName: json['accountName'] as String? ?? '',
        accountNo: json['accountNo'] as String? ?? '',
        bankName: json['bankName'] as String? ?? '',
        swift: json['swift'] as String? ?? '',
        method: json['method'] as String? ?? 'PayPal',
      );
}

class InvoiceModel {
  final String id;
  final String clientName; // Kept for backward compatibility
  final String invNo; // Kept for backward compatibility
  final String date; // Kept for backward compatibility
  final double amount;
  final double dueAmount;
  final String dueDate; // Kept for backward compatibility
  final InvoiceStatus status;
  final List<InvoiceItemModel> items;
  
  final InvoiceInfo? info;
  final Party? billFrom;
  final Party? billTo;
  final PaymentInfo? payment;

  InvoiceModel({
    required this.id,
    required this.clientName,
    required this.invNo,
    required this.date,
    required this.amount,
    required this.dueAmount,
    required this.dueDate,
    required this.status,
    this.items = const [],
    this.info,
    this.billFrom,
    this.billTo,
    this.payment,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientName': clientName,
        'invNo': invNo,
        'date': date,
        'amount': amount,
        'dueAmount': dueAmount,
        'dueDate': dueDate,
        'status': status.index,
        'items': items.map((i) => i.toJson()).toList(),
        'info': info?.toJson(),
        'billFrom': billFrom?.toJson(),
        'billTo': billTo?.toJson(),
        'payment': payment?.toJson(),
      };

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json['id'] as String,
        clientName: json['clientName'] as String,
        invNo: json['invNo'] as String,
        date: json['date'] as String,
        amount: (json['amount'] as num).toDouble(),
        dueAmount: (json['dueAmount'] as num).toDouble(),
        dueDate: json['dueDate'] as String,
        status: InvoiceStatus.values[json['status'] as int],
        items: (json['items'] as List<dynamic>)
            .map((i) => InvoiceItemModel.fromJson(i as Map<String, dynamic>))
            .toList(),
        info: json['info'] != null ? InvoiceInfo.fromJson(json['info'] as Map<String, dynamic>) : null,
        billFrom: json['billFrom'] != null ? Party.fromJson(json['billFrom'] as Map<String, dynamic>) : null,
        billTo: json['billTo'] != null ? Party.fromJson(json['billTo'] as Map<String, dynamic>) : null,
        payment: json['payment'] != null ? PaymentInfo.fromJson(json['payment'] as Map<String, dynamic>) : null,
      );

  String toJsonString() => jsonEncode(toJson());

  static InvoiceModel fromJsonString(String s) =>
      InvoiceModel.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
