import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/create_expense.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/delete_expense.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/edit_expense.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/get_expense.dart';

part 'expense_event.dart';
part 'expense_state.dart';

@injectable
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc(this._get, this._create, this._edit, this._delete)
      : super(ExpenseInitial());
  final GetExpense _get;
  final CreateExpense _create;
  final EditExpense _edit;
  final DeleteExpense _delete;

  @override
  Stream<ExpenseState> mapEventToState(
    ExpenseEvent event,
  ) async* {
    if (event is GetExpenseEvent) {
      yield ExpenseLoading();
      final _res = await _get.call(NoParams());
      yield _res.fold((l) => ExpenseError(), (expenses) {
        return ExpenseSuccess(
            expense: expenses.expense, total: expenses.total!);
      });
    }
    if (event is RefreshExpenseEvent) {
      yield ExpenseRefreshing();
      final _res = await _get.call(NoParams());
      yield _res.fold((l) => ExpenseError(),
          (r) => ExpenseSuccess(expense: r.expense, total: r.total!));
    }
    if (event is CreateExpenseEvent) {
      yield ExpenseUpdating();
      final _res = await _create.call(ObjectParams(event.model));
      yield _res.fold(
        (l) => ExpenseError(),
        (expense) => ExpenseSuccess(
          total: event.total + expense.ammount,
          expense: [
            ...[expense],
            ...event.list
          ],
        ),
      );
    }
    if (event is EditExpenseEvent) {
      yield ExpenseUpdating();
      final _res = await _edit.call(ObjectParams(event.model));
      yield _res.fold(
        (l) => ExpenseError(),
        (expense) => ExpenseSuccess(
          total: (event.total - event.initial.ammount) + expense.ammount,
          expense: event.list
            ..removeWhere((item) => item.id == event.model.id)
            ..insert(event.index, expense),
        ),
      );
    }
    if (event is DeleteExpenseEvent) {
      yield ExpenseUpdating();
      final _res = await _delete.call(ObjectParams(event.model));
      yield _res.fold(
        (l) => ExpenseError(),
        (expense) => ExpenseSuccess(
          total: event.total - event.model.ammount,
          expense: event.list..removeWhere((item) => item.id == event.model.id),
        ),
      );
    }
  }
}
