import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class ExpenseModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "expense")
  final String expense;
  @JsonKey(name: "amount")
  final double amount;
  @JsonKey(name: "static")
  final bool isStatic;

  ExpenseModel({
    required this.id,
    required this.expense,
    required this.amount,
    required this.isStatic,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return _$ExpenseModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  ExpenseModel copyWith({
    int? id,
    String? expense,
    double? amount,
    bool? isStatic,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      expense: expense ?? this.expense,
      amount: amount ?? this.amount,
      isStatic: isStatic ?? this.isStatic,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseModel &&
        other.id == id &&
        other.expense == expense &&
        other.amount == amount &&
        other.isStatic == isStatic;
  }

  @override
  int get hashCode {
    return id.hashCode ^ expense.hashCode ^ amount.hashCode ^ isStatic.hashCode;
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, expense: $expense, amount: $amount, isStatic: $isStatic)';
  }
}
