part of 'expense_bloc.dart';

@immutable
abstract class ExpenseEvent {}

class GetExpenseEvent extends ExpenseEvent {}

class RefreshExpenseEvent extends ExpenseEvent {}

class CreateExpenseEvent extends ExpenseEvent {
  final List<ExpenseModel> list;
  final ExpenseModel model;
  final double total;

  CreateExpenseEvent({
    required this.list,
    required this.model,
    required this.total,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateExpenseEvent &&
        listEquals(other.list, list) &&
        other.model == model &&
        other.total == total;
  }

  @override
  int get hashCode => list.hashCode ^ model.hashCode ^ total.hashCode;

  @override
  String toString() =>
      'CreateExpenseEvent(list: $list, model: $model, total: $total)';
}

class EditExpenseEvent extends ExpenseEvent {
  final List<ExpenseModel> list;
  final ExpenseModel model;
  final ExpenseModel initial;
  final int index;
  final double total;

  EditExpenseEvent({
    required this.list,
    required this.model,
    required this.initial,
    required this.index,
    required this.total,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EditExpenseEvent &&
        listEquals(other.list, list) &&
        other.model == model &&
        other.initial == initial &&
        other.index == index &&
        other.total == total;
  }

  @override
  int get hashCode {
    return list.hashCode ^
        model.hashCode ^
        initial.hashCode ^
        index.hashCode ^
        total.hashCode;
  }

  @override
  String toString() {
    return 'EditExpenseEvent(list: $list, model: $model, initial: $initial, index: $index, total: $total)';
  }
}

class DeleteExpenseEvent extends ExpenseEvent {
  final List<ExpenseModel> list;
  final ExpenseModel model;
  final double total;

  DeleteExpenseEvent({
    required this.list,
    required this.model,
    required this.total,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeleteExpenseEvent &&
        listEquals(other.list, list) &&
        other.model == model &&
        other.total == total;
  }

  @override
  int get hashCode => list.hashCode ^ model.hashCode ^ total.hashCode;

  @override
  String toString() =>
      'DeleteExpenseEvent(list: $list, model: $model, total: $total)';
}
