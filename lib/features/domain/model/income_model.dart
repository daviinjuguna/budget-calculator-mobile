import 'package:json_annotation/json_annotation.dart';

part 'income_model.g.dart';

@JsonSerializable()
class IncomeModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "income")
  final String income;
  @JsonKey(name: "amount")
  final double amount;

  IncomeModel({
    required this.id,
    required this.income,
    required this.amount,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return _$IncomeModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$IncomeModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncomeModel &&
        other.id == id &&
        other.income == income &&
        other.amount == amount;
  }

  @override
  int get hashCode => id.hashCode ^ income.hashCode ^ amount.hashCode;

  IncomeModel copyWith({
    int? id,
    String? income,
    double? amount,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      income: income ?? this.income,
      amount: amount ?? this.amount,
    );
  }

  @override
  String toString() => 'IncomeModel(id: $id, income: $income, amount: $amount)';
}
