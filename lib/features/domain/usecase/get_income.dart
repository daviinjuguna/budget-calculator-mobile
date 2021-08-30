import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';

@lazySingleton
class GetIncome extends UseCase<List<IncomeModel>, NoParams> {
  GetIncome(this._repository);

  @override
  Future<Either<String, List<IncomeModel>>> call(NoParams p) {
    return _repository.getIncome();
  }

  final Repository _repository;
}
