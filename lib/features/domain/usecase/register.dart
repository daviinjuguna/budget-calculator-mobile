import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';

import 'login.dart';

@lazySingleton
class Register extends UseCase<String, AuthParams> {
  Register(this._repository);

  @override
  Future<Either<String, String>> call(AuthParams p) {
    return _repository.register(phone: p.phone, pass: p.pass, name: p.name);
  }

  final Repository _repository;
}
