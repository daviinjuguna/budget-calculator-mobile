// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) {
  return ExpenseModel(
    id: json['id'] as int,
    expense: json['expense'] as String,
    ammount: (json['amount'] as num?)?.toDouble(),
    percentageAmmount: (json['percent'] as num?)?.toDouble(),
    isStatic: json['static'] as bool,
  );
}

Map<String, dynamic> _$ExpenseModelToJson(ExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expense': instance.expense,
      'amount': instance.ammount,
      'percent': instance.percentageAmmount,
      'static': instance.isStatic,
    };
