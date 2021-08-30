import 'package:sortika_budget_calculator/core/errors/network_error_converter.dart';
import 'package:sortika_budget_calculator/features/domain/model/profile_model.dart';
import 'package:sortika_budget_calculator/features/domain/model/user_model.dart';

class AuthResponse {
  final UserModel? user;
  final ProfileModel? profile;
  final String token;
  final String? error;

  AuthResponse({required this.user, required this.profile, required this.token})
      : assert(user != null && profile != null),
        assert(token.isNotEmpty),
        error = null;
  AuthResponse.withError(String errorValue)
      : error = networkErrorConverter(errorValue),
        user = null,
        token = "",
        profile = null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthResponse &&
        other.user == user &&
        other.profile == profile &&
        other.error == error;
  }

  @override
  int get hashCode => user.hashCode ^ profile.hashCode ^ error.hashCode;

  @override
  String toString() =>
      'AuthResponse(user: $user, profile: $profile, error: $error)';
}
