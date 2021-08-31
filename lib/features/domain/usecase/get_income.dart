import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';
import 'package:sortika_budget_calculator/features/data/response/income_response.dart';

@lazySingleton
class GetIncome extends UseCase<IncomeResponse, NoParams> {
  GetIncome(this._repository);

  @override
  Future<Either<String, IncomeResponse>> call(NoParams p) {
    return _repository.getIncome();
  }

  final Repository _repository;
}
