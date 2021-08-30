import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';

@lazySingleton
class CreateIncome extends UseCase<IncomeModel, ObjectParams<IncomeModel>> {
  CreateIncome(this._repository);

  @override
  Future<Either<String, IncomeModel>> call(ObjectParams<IncomeModel> p) {
    return _repository.createIncome(p.object);
  }

  final Repository _repository;
}
