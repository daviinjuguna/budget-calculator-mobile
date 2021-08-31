part of 'income_bloc.dart';

@immutable
abstract class IncomeEvent {}

class GetIncomeEvent extends IncomeEvent {}

class RefreshIncomeEvent extends IncomeEvent {}

class CreateIncomeEvent extends IncomeEvent {
  final List<IncomeModel> list;
  final IncomeModel model;
  final double total;
  CreateIncomeEvent({
    required this.list,
    required this.model,
    required this.total,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateIncomeEvent &&
        listEquals(other.list, list) &&
        other.model == model &&
        other.total == total;
  }

  @override
  int get hashCode => list.hashCode ^ model.hashCode ^ total.hashCode;

  @override
  String toString() =>
      'CreateIncomeEvent(list: $list, model: $model, total: $total)';
}

class EditIncomeEvent extends IncomeEvent {
  final List<IncomeModel> list;
  final IncomeModel model;
  final IncomeModel initial;
  final int index;
  final double total;

  EditIncomeEvent({
    required this.list,
    required this.model,
    required this.initial,
    required this.index,
    required this.total,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EditIncomeEvent &&
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
    return 'EditIncomeEvent(list: $list, model: $model, initial: $initial, index: $index, total: $total)';
  }
}

class DeleteIncomeEvent extends IncomeEvent {
  final List<IncomeModel> list;
  final IncomeModel model;
  final double total;

  DeleteIncomeEvent({
    required this.list,
    required this.model,
    required this.total,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeleteIncomeEvent &&
        listEquals(other.list, list) &&
        other.model == model &&
        other.total == total;
  }

  @override
  int get hashCode => list.hashCode ^ model.hashCode ^ total.hashCode;

  @override
  String toString() =>
      'DeleteIncomeEvent(list: $list, model: $model, total: $total)';
}
