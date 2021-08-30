import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';

@lazySingleton
class DeleteExpense extends UseCase<String, ObjectParams<ExpenseModel>> {
  DeleteExpense(this._repository);

  @override
  Future<Either<String, String>> call(ObjectParams<ExpenseModel> p) {
    return _repository.deleteExpense(p.object);
  }

  final Repository _repository;
}
