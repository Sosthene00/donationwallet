// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_definitions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Error {
  Error get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Error field0) jsonError,
    required TResult Function(Error field0) nakamotoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Error field0)? jsonError,
    TResult? Function(Error field0)? nakamotoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Error field0)? jsonError,
    TResult Function(Error field0)? nakamotoError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Error_JsonError value) jsonError,
    required TResult Function(Error_NakamotoError value) nakamotoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Error_JsonError value)? jsonError,
    TResult? Function(Error_NakamotoError value)? nakamotoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Error_JsonError value)? jsonError,
    TResult Function(Error_NakamotoError value)? nakamotoError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ErrorCopyWith<Error> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) then) =
      _$ErrorCopyWithImpl<$Res, Error>;
  @useResult
  $Res call({Error field0});

  $ErrorCopyWith<$Res> get field0;
}

/// @nodoc
class _$ErrorCopyWithImpl<$Res, $Val extends Error>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_value.copyWith(
      field0: null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Error,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ErrorCopyWith<$Res> get field0 {
    return $ErrorCopyWith<$Res>(_value.field0, (value) {
      return _then(_value.copyWith(field0: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$Error_JsonErrorCopyWith<$Res>
    implements $ErrorCopyWith<$Res> {
  factory _$$Error_JsonErrorCopyWith(
          _$Error_JsonError value, $Res Function(_$Error_JsonError) then) =
      __$$Error_JsonErrorCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Error field0});

  @override
  $ErrorCopyWith<$Res> get field0;
}

/// @nodoc
class __$$Error_JsonErrorCopyWithImpl<$Res>
    extends _$ErrorCopyWithImpl<$Res, _$Error_JsonError>
    implements _$$Error_JsonErrorCopyWith<$Res> {
  __$$Error_JsonErrorCopyWithImpl(
      _$Error_JsonError _value, $Res Function(_$Error_JsonError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Error_JsonError(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Error,
    ));
  }
}

/// @nodoc

class _$Error_JsonError implements Error_JsonError {
  const _$Error_JsonError(this.field0);

  @override
  final Error field0;

  @override
  String toString() {
    return 'Error.jsonError(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error_JsonError &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Error_JsonErrorCopyWith<_$Error_JsonError> get copyWith =>
      __$$Error_JsonErrorCopyWithImpl<_$Error_JsonError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Error field0) jsonError,
    required TResult Function(Error field0) nakamotoError,
  }) {
    return jsonError(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Error field0)? jsonError,
    TResult? Function(Error field0)? nakamotoError,
  }) {
    return jsonError?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Error field0)? jsonError,
    TResult Function(Error field0)? nakamotoError,
    required TResult orElse(),
  }) {
    if (jsonError != null) {
      return jsonError(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Error_JsonError value) jsonError,
    required TResult Function(Error_NakamotoError value) nakamotoError,
  }) {
    return jsonError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Error_JsonError value)? jsonError,
    TResult? Function(Error_NakamotoError value)? nakamotoError,
  }) {
    return jsonError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Error_JsonError value)? jsonError,
    TResult Function(Error_NakamotoError value)? nakamotoError,
    required TResult orElse(),
  }) {
    if (jsonError != null) {
      return jsonError(this);
    }
    return orElse();
  }
}

abstract class Error_JsonError implements Error {
  const factory Error_JsonError(final Error field0) = _$Error_JsonError;

  @override
  Error get field0;
  @override
  @JsonKey(ignore: true)
  _$$Error_JsonErrorCopyWith<_$Error_JsonError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Error_NakamotoErrorCopyWith<$Res>
    implements $ErrorCopyWith<$Res> {
  factory _$$Error_NakamotoErrorCopyWith(_$Error_NakamotoError value,
          $Res Function(_$Error_NakamotoError) then) =
      __$$Error_NakamotoErrorCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Error field0});

  @override
  $ErrorCopyWith<$Res> get field0;
}

/// @nodoc
class __$$Error_NakamotoErrorCopyWithImpl<$Res>
    extends _$ErrorCopyWithImpl<$Res, _$Error_NakamotoError>
    implements _$$Error_NakamotoErrorCopyWith<$Res> {
  __$$Error_NakamotoErrorCopyWithImpl(
      _$Error_NakamotoError _value, $Res Function(_$Error_NakamotoError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Error_NakamotoError(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Error,
    ));
  }
}

/// @nodoc

class _$Error_NakamotoError implements Error_NakamotoError {
  const _$Error_NakamotoError(this.field0);

  @override
  final Error field0;

  @override
  String toString() {
    return 'Error.nakamotoError(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error_NakamotoError &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Error_NakamotoErrorCopyWith<_$Error_NakamotoError> get copyWith =>
      __$$Error_NakamotoErrorCopyWithImpl<_$Error_NakamotoError>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Error field0) jsonError,
    required TResult Function(Error field0) nakamotoError,
  }) {
    return nakamotoError(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Error field0)? jsonError,
    TResult? Function(Error field0)? nakamotoError,
  }) {
    return nakamotoError?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Error field0)? jsonError,
    TResult Function(Error field0)? nakamotoError,
    required TResult orElse(),
  }) {
    if (nakamotoError != null) {
      return nakamotoError(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Error_JsonError value) jsonError,
    required TResult Function(Error_NakamotoError value) nakamotoError,
  }) {
    return nakamotoError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Error_JsonError value)? jsonError,
    TResult? Function(Error_NakamotoError value)? nakamotoError,
  }) {
    return nakamotoError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Error_JsonError value)? jsonError,
    TResult Function(Error_NakamotoError value)? nakamotoError,
    required TResult orElse(),
  }) {
    if (nakamotoError != null) {
      return nakamotoError(this);
    }
    return orElse();
  }
}

abstract class Error_NakamotoError implements Error {
  const factory Error_NakamotoError(final Error field0) = _$Error_NakamotoError;

  @override
  Error get field0;
  @override
  @JsonKey(ignore: true)
  _$$Error_NakamotoErrorCopyWith<_$Error_NakamotoError> get copyWith =>
      throw _privateConstructorUsedError;
}
