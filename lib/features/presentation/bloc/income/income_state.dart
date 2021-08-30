part of 'income_bloc.dart';

@immutable
abstract class IncomeState {}

class IncomeInitial extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeRefreshing extends IncomeState {}

class IncomeUpdting extends IncomeState {}

class IncomeSuccess extends IncomeState {
  final List<IncomeModel> income;
  IncomeSuccess({
    required this.income,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncomeSuccess && listEquals(other.income, income);
  }

  @override
  int get hashCode => income.hashCode;

  @override
  String toString() => 'IncomeSuccess(income: $income)';
}

class IncomeError extends IncomeState {}
