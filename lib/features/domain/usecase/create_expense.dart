import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';

@lazySingleton
class CreateExpense extends UseCase<ExpenseModel, ObjectParams<ExpenseModel>> {
  CreateExpense(this._repository);

  @override
  Future<Either<String, ExpenseModel>> call(ObjectParams<ExpenseModel> p) {
    return _repository.createExpense(p.object);
  }

  final Repository _repository;
}
