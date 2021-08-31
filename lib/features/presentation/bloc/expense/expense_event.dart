part of 'expense_bloc.dart';

@immutable
abstract class ExpenseEvent {}

class GetExpenseEvent extends ExpenseEvent {}

class RefreshExpenseEvent extends ExpenseEvent {}

class CreateExpenseEvent extends ExpenseEvent {
  final List<ExpenseModel> list;
  final ExpenseModel model;
  CreateExpenseEvent({
    required this.list,
    required this.model,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateExpenseEvent &&
        listEquals(other.list, list) &&
        other.model == model;
  }

  @override
  int get hashCode => list.hashCode ^ model.hashCode;

  @override
  String toString() => 'CreateExpenseEvent(list: $list, model: $model)';
}

class EditExpenseEvent extends ExpenseEvent {
  final List<ExpenseModel> list;
  final ExpenseModel model;
  final int index;
  EditExpenseEvent({
    required this.list,
    required this.model,
    required this.index,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EditExpenseEvent &&
        listEquals(other.list, list) &&
        other.model == model &&
        other.index == index;
  }

  @override
  int get hashCode => list.hashCode ^ model.hashCode ^ index.hashCode;

  @override
  String toString() =>
      'EditExpenseEvent(list: $list, model: $model, index: $index)';
}

class DeleteExpenseEvent extends ExpenseEvent {
  final List<ExpenseModel> list;
  final ExpenseModel model;
  DeleteExpenseEvent({
    required this.list,
    required this.model,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeleteExpenseEvent &&
        listEquals(other.list, list) &&
        other.model == model;
  }

  @override
  int get hashCode => list.hashCode ^ model.hashCode;

  @override
  String toString() => 'DeleteExpenseEvent(list: $list, model: $model)';
}
