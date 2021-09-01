import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';
import 'package:sortika_budget_calculator/features/data/response/expense_response.dart';

@lazySingleton
class GetExpense extends UseCase<ExpenseResponse, NoParams> {
  GetExpense(this._repository);

  @override
  Future<Either<String, ExpenseResponse>> call(NoParams p) {
    return _repository.getExpense();
  }

  final Repository _repository;
}
