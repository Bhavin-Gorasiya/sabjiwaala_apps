class TransactionModel {
  String? status;
  String? itemAmt;
  String? transactionAmt;
  int? remainingAmt;

  TransactionModel({
    this.status,
    this.itemAmt,
    this.transactionAmt,
    this.remainingAmt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    status: json["status"] ?? "",
    itemAmt: json["ItemAmt"] ?? "",
    transactionAmt: json["TransactionAmt"] ?? "",
    remainingAmt: json["RemainingAmt"] ?? 0,
  );
}

class TransactionList {
  String? transactionsId;
  String? transactionsUname;
  String? transactionsPname;
  String? transactionsUid;
  String? transactionsPid;
  String? transactionsType;
  String? transactionsPMode;
  String? transactionsAmount;
  String? transactionsPdf;
  DateTime? transactionsDate;

  TransactionList({
    this.transactionsId,
    this.transactionsUname,
    this.transactionsPname,
    this.transactionsUid,
    this.transactionsPid,
    this.transactionsType,
    this.transactionsPMode,
    this.transactionsAmount,
    this.transactionsPdf,
    this.transactionsDate,
  });

  factory TransactionList.fromJson(Map<String, dynamic> json) => TransactionList(
    transactionsId: json["transactionsID"] ?? "",
    transactionsUname: json["transactionsUname"] ?? "",
    transactionsPname: json["transactionsPname"] ?? "",
    transactionsUid: json["transactionsUID"] ?? "",
    transactionsPid: json["transactionsPid"] ?? "",
    transactionsType: json["transactionsType"] ?? "",
    transactionsPMode: json["transactionsPMode"] ?? "",
    transactionsAmount: json["transactionsAmount"] ?? "",
    transactionsPdf: json["transactionsPdf"] ?? "",
    transactionsDate: json["transactionsDate"] == null ? null : DateTime.parse(json["transactionsDate"]),
  );
}
