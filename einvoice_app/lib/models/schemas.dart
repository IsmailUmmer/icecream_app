import 'package:isar/isar.dart';
import 'invoice.dart';
import 'transaction.dart';

part 'schemas.g.dart';

@collection
class InvoiceSchema {
  Id id = Isar.autoIncrement;

  late String remoteId;
  late String clientName;
  late String invNo;
  late String date;
  late double amount;
  late double dueAmount;
  late String dueDate;

  @enumerated
  late InvoiceStatus status;

  late List<InvoiceItemSchema> items;
}

@embedded
class InvoiceItemSchema {
  late String name;
  late int quantity;
  late double price;
}

@collection
class TransactionSchema {
  Id id = Isar.autoIncrement;

  late String remoteId;
  late String name;
  late double amount;
  late String date;

  @enumerated
  late TransactionType type;

  @enumerated
  late TransactionStatus status;
}
