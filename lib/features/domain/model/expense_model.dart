import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

// {"id":1,"expense":"Housing","amount":7000.0,"static":false,"user":1}
@JsonSerializable()
class ExpenseModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "expense")
  final String expense;
  @JsonKey(name: "amount")
  final double ammount;
  @JsonKey(name: "static")
  final bool isStatic;
  @JsonKey(name: "recommended")
  final double recommended;

  ExpenseModel({
    required this.id,
    required this.expense,
    required this.ammount,
    required this.isStatic,
    required this.recommended,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return _$ExpenseModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  ExpenseModel copyWith({
    int? id,
    String? expense,
    double? ammount,
    bool? isStatic,
    String? color,
    double? recommended,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      expense: expense ?? this.expense,
      ammount: ammount ?? this.ammount,
      isStatic: isStatic ?? this.isStatic,
      recommended: recommended ?? this.recommended,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseModel &&
        other.id == id &&
        other.expense == expense &&
        other.ammount == ammount &&
        other.isStatic == isStatic &&
        other.recommended == recommended;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        expense.hashCode ^
        ammount.hashCode ^
        isStatic.hashCode ^
        recommended.hashCode;
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, expense: $expense, ammount: $ammount, isStatic: $isStatic,  recommended: $recommended)';
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
