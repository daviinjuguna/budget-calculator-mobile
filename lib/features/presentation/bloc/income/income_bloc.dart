import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/create_income.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/delete_income.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/edit_income.dart';
import 'package:sortika_budget_calculator/features/domain/usecase/get_income.dart';

part 'income_event.dart';
part 'income_state.dart';

@injectable
class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  IncomeBloc(this._get, this._create, this._edit, this._delete)
      : super(IncomeInitial());

  final GetIncome _get;
  final CreateIncome _create;
  final EditIncome _edit;
  final DeleteIncome _delete;

  @override
  Stream<IncomeState> mapEventToState(
    IncomeEvent event,
  ) async* {
    if (event is GetIncomeEvent) {
      yield IncomeLoading();
      final _res = await _get.call(NoParams());
      yield _res.fold(
        (l) => IncomeError(),
        (r) {
          if (r.incomes.isEmpty) {}
          return IncomeSuccess(income: r.incomes, total: r.total!);
        },
      );
    }
    if (event is RefreshIncomeEvent) {
      yield IncomeRefreshing();
      final _res = await _get.call(NoParams());
      yield _res.fold(
        (l) => IncomeError(),
        (r) => IncomeSuccess(income: r.incomes, total: r.total!),
      );
    }
    if (event is CreateIncomeEvent) {
      yield IncomeUpdting();
      final _res = await _create.call(ObjectParams(event.model));

      yield _res.fold(
        (l) => IncomeError(),
        (income) => IncomeSuccess(
          total: event.total + income.amount,
          income: [
            ...[income],
            ...event.list
          ],
        ),
      );
    }
    if (event is EditIncomeEvent) {
      yield IncomeUpdting();
      final _res = await _edit.call(ObjectParams(event.model));

      yield _res.fold((l) => IncomeError(), (income) {
        final _diff = event.total - event.initial.amount;
        print(_diff);
        return IncomeSuccess(
            total: _diff + income.amount,
            income: event.list
              ..removeWhere((item) => item.id == event.model.id)
              ..insert(event.index, income));
      });
    }

    if (event is DeleteIncomeEvent) {
      yield IncomeUpdting();
      final _res = await _delete.call(ObjectParams(event.model));

      yield _res.fold(
        (l) => IncomeError(),
        (income) => IncomeSuccess(
            total: event.total - event.model.amount,
            income: event.list
              ..removeWhere((item) => item.id == event.model.id)),
      );
    }
  }
}
