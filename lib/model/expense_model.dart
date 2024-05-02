// ignore_for_file: public_member_api_docs, sort_constructors_first

class Expense {
  final String id;
  final DateTime dateTime;
  final String description;
  final double amount;

  Expense({
    required this.id,
    required this.dateTime,
    required this.description,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
      'amount': amount,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      description: json['description'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'description': description,
      'amount': amount,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      description: map['description'] as String,
      amount: map['amount'] as double,
    );
  }

  Expense copyWith({
    String? id,
    DateTime? dateTime,
    String? description,
    double? amount,
  }) {
    return Expense(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      amount: amount ?? this.amount,
    );
  }
}
