import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';
import 'package:sortika_budget_calculator/features/domain/model/income_model.dart';

@lazySingleton
class DeleteIncome extends UseCase<String, ObjectParams<IncomeModel>> {
  DeleteIncome(this._repository);

  @override
  Future<Either<String, String>> call(ObjectParams<IncomeModel> p) {
    return _repository.deleteIncome(p.object);
  }

  final Repository _repository;
}
