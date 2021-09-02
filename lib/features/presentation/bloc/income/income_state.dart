part of 'income_bloc.dart';

@immutable
abstract class IncomeState {}

class IncomeInitial extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeCreating extends IncomeState {}

class IncomeDeleting extends IncomeState {}

class IncomeRefreshing extends IncomeState {}

class IncomeUpdting extends IncomeState {}

class IncomeSuccess extends IncomeState {
  final List<IncomeModel> income;
  final double total;
  IncomeSuccess({
    required this.income,
    required this.total,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncomeSuccess &&
        listEquals(other.income, income) &&
        other.total == total;
  }

  @override
  int get hashCode => income.hashCode ^ total.hashCode;

  @override
  String toString() => 'IncomeSuccess(income: $income, total: $total)';
}

class IncomeError extends IncomeState {}
