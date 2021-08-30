import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';

@lazySingleton
class CheckAuth extends UseCase<bool, NoParams> {
  CheckAuth(this._repository);

  @override
  Future<Either<String, bool>> call(NoParams p) {
    return _repository.checkAuth();
  }

  final Repository _repository;
}
