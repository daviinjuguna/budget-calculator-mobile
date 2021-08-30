import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sortika_budget_calculator/core/utils/usecase.dart';
import 'package:sortika_budget_calculator/features/data/repo/repository.dart';

@lazySingleton
class Login extends UseCase<String, AuthParams> {
  Login(this._repository);

  @override
  Future<Either<String, String>> call(AuthParams p) {
    return _repository.login(phone: p.phone, pass: p.pass);
  }

  final Repository _repository;
}

class AuthParams {
  final String phone;
  final String pass;
  final String? name;
  AuthParams({
    required this.phone,
    required this.pass,
    this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthParams &&
        other.phone == phone &&
        other.pass == pass &&
        other.name == name;
  }

  @override
  int get hashCode => phone.hashCode ^ pass.hashCode ^ name.hashCode;

  @override
  String toString() => 'AuthParams(phone: $phone, pass: $pass, name: $name)';
}
