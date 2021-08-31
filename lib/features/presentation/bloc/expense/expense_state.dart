part of 'expense_bloc.dart';

@immutable
abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseSuccess extends ExpenseState {
  final List<ExpenseModel> expense;
  ExpenseSuccess({
    required this.expense,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseSuccess && listEquals(other.expense, expense);
  }

  @override
  int get hashCode => expense.hashCode;

  @override
  String toString() => 'ExpenseSuccess(expense: $expense)';
}

class ExpenseError extends ExpenseState {}

class ExpenseUpdating extends ExpenseState {}
