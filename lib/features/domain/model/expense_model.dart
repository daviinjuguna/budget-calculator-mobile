import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class ExpenseModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "expense")
  final String expense;
  @JsonKey(name: "amount")
  final double? ammount;
  @JsonKey(name: "percent")
  final double? percentageAmmount;
  @JsonKey(name: "static")
  final bool isStatic;

  ExpenseModel({
    required this.id,
    required this.expense,
    this.ammount,
    this.percentageAmmount,
    required this.isStatic,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return _$ExpenseModelFromJson(json);
  }

  factory ExpenseModel.defaultExpense(
          {required String expense, required double percent}) =>
      ExpenseModel(
        id: 1,
        expense: expense,
        isStatic: false,
        percentageAmmount: percent,
      );

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  ExpenseModel copyWith({
    int? id,
    String? expense,
    double? ammount,
    double? percentageAmmount,
    bool? isStatic,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      expense: expense ?? this.expense,
      ammount: ammount ?? this.ammount,
      percentageAmmount: percentageAmmount ?? this.percentageAmmount,
      isStatic: isStatic ?? this.isStatic,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseModel &&
        other.id == id &&
        other.expense == expense &&
        other.ammount == ammount &&
        other.percentageAmmount == percentageAmmount &&
        other.isStatic == isStatic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        expense.hashCode ^
        ammount.hashCode ^
        percentageAmmount.hashCode ^
        isStatic.hashCode;
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, expense: $expense, ammount: $ammount, percentageAmmount: $percentageAmmount, isStatic: $isStatic)';
  }
}
