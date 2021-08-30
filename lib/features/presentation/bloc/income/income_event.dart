part of 'income_bloc.dart';

@immutable
abstract class IncomeEvent {}

class GetIncomeEvent extends IncomeEvent {}

class RefreshIncomeEvent extends IncomeEvent {}

class CreateIncomeEvent extends IncomeEvent {
  final List<IncomeModel> list;
  final IncomeModel model;
  CreateIncomeEvent({
    required this.list,
    required this.model,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateIncomeEvent &&
        listEquals(other.list, list) &&
        other.model == model;
  }

  @override
  int get hashCode => list.hashCode ^ model.hashCode;

  @override
  String toString() => 'CreateIncomeEvent(list: $list, model: $model)';
}

class EditIncomeEvent extends IncomeEvent {
  final List<IncomeModel> list;
  final IncomeModel model;
  final int index;
  EditIncomeEvent({
    required this.list,
    required this.model,
    required this.index,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EditIncomeEvent &&
        listEquals(other.list, list) &&
        other.model == model &&
        other.index == index;
  }

  @override
  int get hashCode => list.hashCode ^ model.hashCode ^ index.hashCode;

  @override
  String toString() =>
      'EditIncomeEvent(list: $list, model: $model, index: $index)';
}

class DeleteIncomeEvent extends IncomeEvent {
  final List<IncomeModel> list;
  final IncomeModel model;
  DeleteIncomeEvent({
    required this.list,
    required this.model,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeleteIncomeEvent &&
        listEquals(other.list, list) &&
        other.model == model;
  }

  @override
  int get hashCode => list.hashCode ^ model.hashCode;

  @override
  String toString() => 'DeleteIncomeEvent(list: $list, model: $model)';
}
