import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';

@lazySingleton
class EditExpense extends UseCase<ExpenseModel, ObjectParams<ExpenseModel>> {
  EditExpense(this._repository);

  @override
  Future<Either<String, ExpenseModel>> call(ObjectParams<ExpenseModel> p) {
    return _repository.editExpense(p.object);
  }

  final Repository _repository;
}
