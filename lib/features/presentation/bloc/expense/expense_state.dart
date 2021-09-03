part of 'expense_bloc.dart';

@immutable
abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseSuccess extends ExpenseState {
  final List<ExpenseModel> expense;
  final double total;
  ExpenseSuccess({
    required this.expense,
    required this.total,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseSuccess &&
        listEquals(other.expense, expense) &&
        other.total == total;
  }

  @override
  int get hashCode => expense.hashCode ^ total.hashCode;

  @override
  String toString() => 'ExpenseSuccess(expense: $expense, total: $total)';
}

class ExpenseError extends ExpenseState {}

class ExpenseUpdating extends ExpenseState {}

class ExpenseRefreshing extends ExpenseState {}
