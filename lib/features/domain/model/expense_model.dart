import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:math' as math;
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

  @JsonKey(name: 'color')
  final String color;

  ExpenseModel({
    required this.id,
    required this.expense,
    required this.ammount,
    required this.isStatic,
    required this.color,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return _$ExpenseModelFromJson(json);
  }

  factory ExpenseModel.defaultExpense({
    required String expense,
    required double amount,
  }) =>
      ExpenseModel(
        id: 1,
        expense: expense,
        isStatic: false,
        ammount: amount,
        color: "#" +
            (Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0)
                    .value
                    .toRadixString(16)
                    .toUpperCase())
                .lastChars(6),
      );

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  ExpenseModel copyWith({
    int? id,
    String? expense,
    double? ammount,
    bool? isStatic,
    String? color,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      expense: expense ?? this.expense,
      ammount: ammount ?? this.ammount,
      isStatic: isStatic ?? this.isStatic,
      color: color ?? this.color,
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
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        expense.hashCode ^
        ammount.hashCode ^
        isStatic.hashCode ^
        color.hashCode;
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, expense: $expense, ammount: $ammount, isStatic: $isStatic, color: $color)';
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
