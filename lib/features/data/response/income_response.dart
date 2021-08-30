import 'package:flutter/foundation.dart';

import 'package:sortika_budget_calculator/core/errors/network_error_converter.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';

class IncomeResponse {
  final List<IncomeModel> incomes;
  final IncomeModel? singleIncome;
  final String? error;

  IncomeResponse(this.incomes, {this.singleIncome}) : error = null;

  IncomeResponse.single(this.singleIncome)
      : incomes = [],
        error = null;

  IncomeResponse.withError(String errorValue)
      : error = networkErrorConverter(errorValue),
        incomes = [],
        singleIncome = null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncomeResponse &&
        listEquals(other.incomes, incomes) &&
        other.singleIncome == singleIncome &&
        other.error == error;
  }

  @override
  int get hashCode => incomes.hashCode ^ singleIncome.hashCode ^ error.hashCode;

  @override
  String toString() =>
      'IncomeResponse(incomes: $incomes, singleIncome: $singleIncome, error: $error)';
}
