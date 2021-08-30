// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) {
  return ExpenseModel(
    id: json['id'] as int,
    expense: json['expense'] as String,
    percentageAmmount: (json['amount'] as num).toDouble(),
    isStatic: json['static'] as bool,
  );
}

Map<String, dynamic> _$ExpenseModelToJson(ExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expense': instance.expense,
      'amount': instance.percentageAmmount,
      'static': instance.isStatic,
    };
