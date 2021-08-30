import 'package:flutter/foundation.dart';

import 'package:sortika_budget_calculator/core/errors/network_error_converter.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';

class IncomeResponse {
  final List<IncomeModel> incomes;
  final double? total;
  final IncomeModel? singleIncome;
  final String? error;

  IncomeResponse(this.incomes, this.total, {this.singleIncome}) : error = null;

  IncomeResponse.single(this.singleIncome)
      : incomes = [],
        total = null,
        error = null;

  IncomeResponse.withError(String errorValue)
      : error = networkErrorConverter(errorValue),
        incomes = [],
        total = null,
        singleIncome = null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncomeResponse &&
        listEquals(other.incomes, incomes) &&
        other.total == total &&
        other.singleIncome == singleIncome &&
        other.error == error;
  }

  @override
  int get hashCode {
    return incomes.hashCode ^
        total.hashCode ^
        singleIncome.hashCode ^
        error.hashCode;
  }

  @override
  String toString() {
    return 'IncomeResponse(incomes: $incomes, total: $total, singleIncome: $singleIncome, error: $error)';
  }
}
