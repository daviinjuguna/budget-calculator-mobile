import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<String, Type>> call(Params p);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<String, Type>> call(Params p);
}

class NoParams {
  @override
  String toString() => "NoParams()";
}

class ParamsId {
  final int id;

  ParamsId({required this.id});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParamsId && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ParamsId(id: $id)';

  ParamsId copyWith({
    int? id,
  }) {
    return ParamsId(
      id: id ?? this.id,
    );
  }
}

class ParamsIdNullable {
  final int? id;
  ParamsIdNullable({
    this.id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParamsIdNullable && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  ParamsIdNullable copyWith({
    int? id,
  }) {
    return ParamsIdNullable(
      id: id ?? this.id,
    );
  }

  @override
  String toString() => 'ParamsIdNullable(id: $id)';
}

class ParamsString {
  final String string;

  ParamsString({required this.string});

  @override
  String toString() => 'ParamsString(string: $string)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParamsString && other.string == string;
  }

  @override
  int get hashCode => string.hashCode;

  ParamsString copyWith({
    String? string,
  }) {
    return ParamsString(
      string: string ?? this.string,
    );
  }
}

class ParamsStringNullable {
  final String? string;
  ParamsStringNullable({
    this.string,
  });

  ParamsStringNullable copyWith({
    String? string,
  }) {
    return ParamsStringNullable(
      string: string ?? this.string,
    );
  }

  @override
  String toString() => 'ParamsStringNullable(string: $string)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParamsStringNullable && other.string == string;
  }

  @override
  int get hashCode => string.hashCode;
}

class ObjectParams<T> {
  final T object;

  ObjectParams(this.object);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ObjectParams<T> && other.object == object;
  }

  @override
  int get hashCode => object.hashCode;

  @override
  String toString() => 'ObjectParams(object: $object)';

  ObjectParams<T> copyWith({
    T? object,
  }) {
    return ObjectParams<T>(
      object ?? this.object,
    );
  }
}
