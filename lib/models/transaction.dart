import 'dart:convert';

enum TransactionType { sent, received }
enum TransactionStatus { success, processing, failed }

class TransactionModel {
  final String id;
  final String name;
  final double amount;
  final String date;
  final TransactionType type;
  final TransactionStatus status;

  TransactionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'amount': amount,
        'date': date,
        'type': type.index,
        'status': status.index,
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'] as String,
        name: json['name'] as String,
        amount: (json['amount'] as num).toDouble(),
        date: json['date'] as String,
        type: TransactionType.values[json['type'] as int],
        status: TransactionStatus.values[json['status'] as int],
      );

  String toJsonString() => jsonEncode(toJson());

  static TransactionModel fromJsonString(String s) =>
      TransactionModel.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
