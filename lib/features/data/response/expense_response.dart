import 'package:flutter/foundation.dart';

import 'package:sortika_budget_calculator/core/errors/network_error_converter.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';

class ExpenseResponse {
  final List<ExpenseModel> expense;
  final ExpenseModel? singleExpense;
  final String? error;

  ExpenseResponse(this.expense, {this.singleExpense}) : error = null;
  ExpenseResponse.single(this.singleExpense)
      : expense = [],
        error = null;
  ExpenseResponse.withError(String errorValue)
      : expense = [],
        singleExpense = null,
        error = networkErrorConverter(errorValue);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseResponse &&
        listEquals(other.expense, expense) &&
        other.singleExpense == singleExpense &&
        other.error == error;
  }

  @override
  int get hashCode =>
      expense.hashCode ^ singleExpense.hashCode ^ error.hashCode;

  @override
  String toString() =>
      'ExpenseResponse(expense: $expense, singleExpense: $singleExpense, error: $error)';
}
