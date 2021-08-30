part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String phone;
  final String pass;
  AuthLoginEvent({
    required this.phone,
    required this.pass,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthLoginEvent &&
        other.phone == phone &&
        other.pass == pass;
  }

  @override
  int get hashCode => phone.hashCode ^ pass.hashCode;

  @override
  String toString() => 'AuthLoginEvent(phone: $phone, pass: $pass)';
}

class AuthRegisterEvent extends AuthEvent {
  final String phone;
  final String pass;
  final String? name;
  AuthRegisterEvent({
    required this.phone,
    required this.pass,
    this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthRegisterEvent &&
        other.phone == phone &&
        other.pass == pass &&
        other.name == name;
  }

  @override
  int get hashCode => phone.hashCode ^ pass.hashCode ^ name.hashCode;

  @override
  String toString() =>
      'AuthRegisterEvent(phone: $phone, pass: $pass, name: $name)';
}
