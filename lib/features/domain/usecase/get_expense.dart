import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';
import 'package:sortika_budget_calculator/features/domain/model/expense_model.dart';

@lazySingleton
class GetExpense extends UseCase<List<ExpenseModel>, NoParams> {
  GetExpense(this._repository);

  @override
  Future<Either<String, List<ExpenseModel>>> call(NoParams p) {
    return _repository.getExpense();
  }

  final Repository _repository;
}
