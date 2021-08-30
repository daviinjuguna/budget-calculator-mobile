import 'package:json_annotation/json_annotation.dart';
part 'profile_model.g.dart';

@JsonSerializable(includeIfNull: false)
class ProfileModel {
  @JsonKey(name: "name")
  final String? name;

  ProfileModel(this.name);

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return _$ProfileModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'ProfileModel(name: $name)';
}
