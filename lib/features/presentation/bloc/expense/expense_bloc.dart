import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
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
    // TODO: implement mapEventToState
  }
}
