// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeModel _$IncomeModelFromJson(Map<String, dynamic> json) {
  return IncomeModel(
    id: json['id'] as int,
    income: json['income'] as String,
    amount: (json['amount'] as num).toDouble(),
  );
}

Map<String, dynamic> _$IncomeModelToJson(IncomeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'income': instance.income,
      'amount': instance.amount,
    };
