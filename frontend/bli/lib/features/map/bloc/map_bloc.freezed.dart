// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MapEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LatLng position) mapTapped,
    required TResult Function(bool show) searchToggled,
    required TResult Function() errorCleared,
    required TResult Function() mapReset,
    required TResult Function(LatLng location, String addressName)
    locationSelected,
    required TResult Function(LivabilityScore score, LatLng position)
    analysisSucceeded,
    required TResult Function(String errorMessage) analysisFailed,
    required TResult Function() slowLoadingTriggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LatLng position)? mapTapped,
    TResult? Function(bool show)? searchToggled,
    TResult? Function()? errorCleared,
    TResult? Function()? mapReset,
    TResult? Function(LatLng location, String addressName)? locationSelected,
    TResult? Function(LivabilityScore score, LatLng position)?
    analysisSucceeded,
    TResult? Function(String errorMessage)? analysisFailed,
    TResult? Function()? slowLoadingTriggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LatLng position)? mapTapped,
    TResult Function(bool show)? searchToggled,
    TResult Function()? errorCleared,
    TResult Function()? mapReset,
    TResult Function(LatLng location, String addressName)? locationSelected,
    TResult Function(LivabilityScore score, LatLng position)? analysisSucceeded,
    TResult Function(String errorMessage)? analysisFailed,
    TResult Function()? slowLoadingTriggered,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapTapped value) mapTapped,
    required TResult Function(SearchToggled value) searchToggled,
    required TResult Function(ErrorCleared value) errorCleared,
    required TResult Function(MapReset value) mapReset,
    required TResult Function(LocationSelected value) locationSelected,
    required TResult Function(AnalysisSucceeded value) analysisSucceeded,
    required TResult Function(AnalysisFailed value) analysisFailed,
    required TResult Function(SlowLoadingTriggered value) slowLoadingTriggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapTapped value)? mapTapped,
    TResult? Function(SearchToggled value)? searchToggled,
    TResult? Function(ErrorCleared value)? errorCleared,
    TResult? Function(MapReset value)? mapReset,
    TResult? Function(LocationSelected value)? locationSelected,
    TResult? Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult? Function(AnalysisFailed value)? analysisFailed,
    TResult? Function(SlowLoadingTriggered value)? slowLoadingTriggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapTapped value)? mapTapped,
    TResult Function(SearchToggled value)? searchToggled,
    TResult Function(ErrorCleared value)? errorCleared,
    TResult Function(MapReset value)? mapReset,
    TResult Function(LocationSelected value)? locationSelected,
    TResult Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult Function(AnalysisFailed value)? analysisFailed,
    TResult Function(SlowLoadingTriggered value)? slowLoadingTriggered,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapEventCopyWith<$Res> {
  factory $MapEventCopyWith(MapEvent value, $Res Function(MapEvent) then) =
      _$MapEventCopyWithImpl<$Res, MapEvent>;
}

/// @nodoc
class _$MapEventCopyWithImpl<$Res, $Val extends MapEvent>
    implements $MapEventCopyWith<$Res> {
  _$MapEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MapTappedImplCopyWith<$Res> {
  factory _$$MapTappedImplCopyWith(
    _$MapTappedImpl value,
    $Res Function(_$MapTappedImpl) then,
  ) = __$$MapTappedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LatLng position});
}

/// @nodoc
class __$$MapTappedImplCopyWithImpl<$Res>
    extends _$MapEventCopyWithImpl<$Res, _$MapTappedImpl>
    implements _$$MapTappedImplCopyWith<$Res> {
  __$$MapTappedImplCopyWithImpl(
    _$MapTappedImpl _value,
    $Res Function(_$MapTappedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? position = null}) {
    return _then(
      _$MapTappedImpl(
        null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as LatLng,
      ),
    );
  }
}

/// @nodoc

class _$MapTappedImpl implements MapTapped {
  const _$MapTappedImpl(this.position);

  @override
  final LatLng position;

  @override
  String toString() {
    return 'MapEvent.mapTapped(position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapTappedImpl &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @override
  int get hashCode => Object.hash(runtimeType, position);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapTappedImplCopyWith<_$MapTappedImpl> get copyWith =>
      __$$MapTappedImplCopyWithImpl<_$MapTappedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LatLng position) mapTapped,
    required TResult Function(bool show) searchToggled,
    required TResult Function() errorCleared,
    required TResult Function() mapReset,
    required TResult Function(LatLng location, String addressName)
    locationSelected,
    required TResult Function(LivabilityScore score, LatLng position)
    analysisSucceeded,
    required TResult Function(String errorMessage) analysisFailed,
    required TResult Function() slowLoadingTriggered,
  }) {
    return mapTapped(position);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LatLng position)? mapTapped,
    TResult? Function(bool show)? searchToggled,
    TResult? Function()? errorCleared,
    TResult? Function()? mapReset,
    TResult? Function(LatLng location, String addressName)? locationSelected,
    TResult? Function(LivabilityScore score, LatLng position)?
    analysisSucceeded,
    TResult? Function(String errorMessage)? analysisFailed,
    TResult? Function()? slowLoadingTriggered,
  }) {
    return mapTapped?.call(position);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LatLng position)? mapTapped,
    TResult Function(bool show)? searchToggled,
    TResult Function()? errorCleared,
    TResult Function()? mapReset,
    TResult Function(LatLng location, String addressName)? locationSelected,
    TResult Function(LivabilityScore score, LatLng position)? analysisSucceeded,
    TResult Function(String errorMessage)? analysisFailed,
    TResult Function()? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (mapTapped != null) {
      return mapTapped(position);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapTapped value) mapTapped,
    required TResult Function(SearchToggled value) searchToggled,
    required TResult Function(ErrorCleared value) errorCleared,
    required TResult Function(MapReset value) mapReset,
    required TResult Function(LocationSelected value) locationSelected,
    required TResult Function(AnalysisSucceeded value) analysisSucceeded,
    required TResult Function(AnalysisFailed value) analysisFailed,
    required TResult Function(SlowLoadingTriggered value) slowLoadingTriggered,
  }) {
    return mapTapped(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapTapped value)? mapTapped,
    TResult? Function(SearchToggled value)? searchToggled,
    TResult? Function(ErrorCleared value)? errorCleared,
    TResult? Function(MapReset value)? mapReset,
    TResult? Function(LocationSelected value)? locationSelected,
    TResult? Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult? Function(AnalysisFailed value)? analysisFailed,
    TResult? Function(SlowLoadingTriggered value)? slowLoadingTriggered,
  }) {
    return mapTapped?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapTapped value)? mapTapped,
    TResult Function(SearchToggled value)? searchToggled,
    TResult Function(ErrorCleared value)? errorCleared,
    TResult Function(MapReset value)? mapReset,
    TResult Function(LocationSelected value)? locationSelected,
    TResult Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult Function(AnalysisFailed value)? analysisFailed,
    TResult Function(SlowLoadingTriggered value)? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (mapTapped != null) {
      return mapTapped(this);
    }
    return orElse();
  }
}

abstract class MapTapped implements MapEvent {
  const factory MapTapped(final LatLng position) = _$MapTappedImpl;

  LatLng get position;

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapTappedImplCopyWith<_$MapTappedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchToggledImplCopyWith<$Res> {
  factory _$$SearchToggledImplCopyWith(
    _$SearchToggledImpl value,
    $Res Function(_$SearchToggledImpl) then,
  ) = __$$SearchToggledImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool show});
}

/// @nodoc
class __$$SearchToggledImplCopyWithImpl<$Res>
    extends _$MapEventCopyWithImpl<$Res, _$SearchToggledImpl>
    implements _$$SearchToggledImplCopyWith<$Res> {
  __$$SearchToggledImplCopyWithImpl(
    _$SearchToggledImpl _value,
    $Res Function(_$SearchToggledImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? show = null}) {
    return _then(
      _$SearchToggledImpl(
        null == show
            ? _value.show
            : show // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SearchToggledImpl implements SearchToggled {
  const _$SearchToggledImpl(this.show);

  @override
  final bool show;

  @override
  String toString() {
    return 'MapEvent.searchToggled(show: $show)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchToggledImpl &&
            (identical(other.show, show) || other.show == show));
  }

  @override
  int get hashCode => Object.hash(runtimeType, show);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchToggledImplCopyWith<_$SearchToggledImpl> get copyWith =>
      __$$SearchToggledImplCopyWithImpl<_$SearchToggledImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LatLng position) mapTapped,
    required TResult Function(bool show) searchToggled,
    required TResult Function() errorCleared,
    required TResult Function() mapReset,
    required TResult Function(LatLng location, String addressName)
    locationSelected,
    required TResult Function(LivabilityScore score, LatLng position)
    analysisSucceeded,
    required TResult Function(String errorMessage) analysisFailed,
    required TResult Function() slowLoadingTriggered,
  }) {
    return searchToggled(show);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LatLng position)? mapTapped,
    TResult? Function(bool show)? searchToggled,
    TResult? Function()? errorCleared,
    TResult? Function()? mapReset,
    TResult? Function(LatLng location, String addressName)? locationSelected,
    TResult? Function(LivabilityScore score, LatLng position)?
    analysisSucceeded,
    TResult? Function(String errorMessage)? analysisFailed,
    TResult? Function()? slowLoadingTriggered,
  }) {
    return searchToggled?.call(show);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LatLng position)? mapTapped,
    TResult Function(bool show)? searchToggled,
    TResult Function()? errorCleared,
    TResult Function()? mapReset,
    TResult Function(LatLng location, String addressName)? locationSelected,
    TResult Function(LivabilityScore score, LatLng position)? analysisSucceeded,
    TResult Function(String errorMessage)? analysisFailed,
    TResult Function()? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (searchToggled != null) {
      return searchToggled(show);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapTapped value) mapTapped,
    required TResult Function(SearchToggled value) searchToggled,
    required TResult Function(ErrorCleared value) errorCleared,
    required TResult Function(MapReset value) mapReset,
    required TResult Function(LocationSelected value) locationSelected,
    required TResult Function(AnalysisSucceeded value) analysisSucceeded,
    required TResult Function(AnalysisFailed value) analysisFailed,
    required TResult Function(SlowLoadingTriggered value) slowLoadingTriggered,
  }) {
    return searchToggled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapTapped value)? mapTapped,
    TResult? Function(SearchToggled value)? searchToggled,
    TResult? Function(ErrorCleared value)? errorCleared,
    TResult? Function(MapReset value)? mapReset,
    TResult? Function(LocationSelected value)? locationSelected,
    TResult? Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult? Function(AnalysisFailed value)? analysisFailed,
    TResult? Function(SlowLoadingTriggered value)? slowLoadingTriggered,
  }) {
    return searchToggled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapTapped value)? mapTapped,
    TResult Function(SearchToggled value)? searchToggled,
    TResult Function(ErrorCleared value)? errorCleared,
    TResult Function(MapReset value)? mapReset,
    TResult Function(LocationSelected value)? locationSelected,
    TResult Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult Function(AnalysisFailed value)? analysisFailed,
    TResult Function(SlowLoadingTriggered value)? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (searchToggled != null) {
      return searchToggled(this);
    }
    return orElse();
  }
}

abstract class SearchToggled implements MapEvent {
  const factory SearchToggled(final bool show) = _$SearchToggledImpl;

  bool get show;

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchToggledImplCopyWith<_$SearchToggledImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorClearedImplCopyWith<$Res> {
  factory _$$ErrorClearedImplCopyWith(
    _$ErrorClearedImpl value,
    $Res Function(_$ErrorClearedImpl) then,
  ) = __$$ErrorClearedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ErrorClearedImplCopyWithImpl<$Res>
    extends _$MapEventCopyWithImpl<$Res, _$ErrorClearedImpl>
    implements _$$ErrorClearedImplCopyWith<$Res> {
  __$$ErrorClearedImplCopyWithImpl(
    _$ErrorClearedImpl _value,
    $Res Function(_$ErrorClearedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ErrorClearedImpl implements ErrorCleared {
  const _$ErrorClearedImpl();

  @override
  String toString() {
    return 'MapEvent.errorCleared()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ErrorClearedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LatLng position) mapTapped,
    required TResult Function(bool show) searchToggled,
    required TResult Function() errorCleared,
    required TResult Function() mapReset,
    required TResult Function(LatLng location, String addressName)
    locationSelected,
    required TResult Function(LivabilityScore score, LatLng position)
    analysisSucceeded,
    required TResult Function(String errorMessage) analysisFailed,
    required TResult Function() slowLoadingTriggered,
  }) {
    return errorCleared();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LatLng position)? mapTapped,
    TResult? Function(bool show)? searchToggled,
    TResult? Function()? errorCleared,
    TResult? Function()? mapReset,
    TResult? Function(LatLng location, String addressName)? locationSelected,
    TResult? Function(LivabilityScore score, LatLng position)?
    analysisSucceeded,
    TResult? Function(String errorMessage)? analysisFailed,
    TResult? Function()? slowLoadingTriggered,
  }) {
    return errorCleared?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LatLng position)? mapTapped,
    TResult Function(bool show)? searchToggled,
    TResult Function()? errorCleared,
    TResult Function()? mapReset,
    TResult Function(LatLng location, String addressName)? locationSelected,
    TResult Function(LivabilityScore score, LatLng position)? analysisSucceeded,
    TResult Function(String errorMessage)? analysisFailed,
    TResult Function()? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (errorCleared != null) {
      return errorCleared();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapTapped value) mapTapped,
    required TResult Function(SearchToggled value) searchToggled,
    required TResult Function(ErrorCleared value) errorCleared,
    required TResult Function(MapReset value) mapReset,
    required TResult Function(LocationSelected value) locationSelected,
    required TResult Function(AnalysisSucceeded value) analysisSucceeded,
    required TResult Function(AnalysisFailed value) analysisFailed,
    required TResult Function(SlowLoadingTriggered value) slowLoadingTriggered,
  }) {
    return errorCleared(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapTapped value)? mapTapped,
    TResult? Function(SearchToggled value)? searchToggled,
    TResult? Function(ErrorCleared value)? errorCleared,
    TResult? Function(MapReset value)? mapReset,
    TResult? Function(LocationSelected value)? locationSelected,
    TResult? Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult? Function(AnalysisFailed value)? analysisFailed,
    TResult? Function(SlowLoadingTriggered value)? slowLoadingTriggered,
  }) {
    return errorCleared?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapTapped value)? mapTapped,
    TResult Function(SearchToggled value)? searchToggled,
    TResult Function(ErrorCleared value)? errorCleared,
    TResult Function(MapReset value)? mapReset,
    TResult Function(LocationSelected value)? locationSelected,
    TResult Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult Function(AnalysisFailed value)? analysisFailed,
    TResult Function(SlowLoadingTriggered value)? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (errorCleared != null) {
      return errorCleared(this);
    }
    return orElse();
  }
}

abstract class ErrorCleared implements MapEvent {
  const factory ErrorCleared() = _$ErrorClearedImpl;
}

/// @nodoc
abstract class _$$MapResetImplCopyWith<$Res> {
  factory _$$MapResetImplCopyWith(
    _$MapResetImpl value,
    $Res Function(_$MapResetImpl) then,
  ) = __$$MapResetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MapResetImplCopyWithImpl<$Res>
    extends _$MapEventCopyWithImpl<$Res, _$MapResetImpl>
    implements _$$MapResetImplCopyWith<$Res> {
  __$$MapResetImplCopyWithImpl(
    _$MapResetImpl _value,
    $Res Function(_$MapResetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$MapResetImpl implements MapReset {
  const _$MapResetImpl();

  @override
  String toString() {
    return 'MapEvent.mapReset()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MapResetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LatLng position) mapTapped,
    required TResult Function(bool show) searchToggled,
    required TResult Function() errorCleared,
    required TResult Function() mapReset,
    required TResult Function(LatLng location, String addressName)
    locationSelected,
    required TResult Function(LivabilityScore score, LatLng position)
    analysisSucceeded,
    required TResult Function(String errorMessage) analysisFailed,
    required TResult Function() slowLoadingTriggered,
  }) {
    return mapReset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LatLng position)? mapTapped,
    TResult? Function(bool show)? searchToggled,
    TResult? Function()? errorCleared,
    TResult? Function()? mapReset,
    TResult? Function(LatLng location, String addressName)? locationSelected,
    TResult? Function(LivabilityScore score, LatLng position)?
    analysisSucceeded,
    TResult? Function(String errorMessage)? analysisFailed,
    TResult? Function()? slowLoadingTriggered,
  }) {
    return mapReset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LatLng position)? mapTapped,
    TResult Function(bool show)? searchToggled,
    TResult Function()? errorCleared,
    TResult Function()? mapReset,
    TResult Function(LatLng location, String addressName)? locationSelected,
    TResult Function(LivabilityScore score, LatLng position)? analysisSucceeded,
    TResult Function(String errorMessage)? analysisFailed,
    TResult Function()? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (mapReset != null) {
      return mapReset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapTapped value) mapTapped,
    required TResult Function(SearchToggled value) searchToggled,
    required TResult Function(ErrorCleared value) errorCleared,
    required TResult Function(MapReset value) mapReset,
    required TResult Function(LocationSelected value) locationSelected,
    required TResult Function(AnalysisSucceeded value) analysisSucceeded,
    required TResult Function(AnalysisFailed value) analysisFailed,
    required TResult Function(SlowLoadingTriggered value) slowLoadingTriggered,
  }) {
    return mapReset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapTapped value)? mapTapped,
    TResult? Function(SearchToggled value)? searchToggled,
    TResult? Function(ErrorCleared value)? errorCleared,
    TResult? Function(MapReset value)? mapReset,
    TResult? Function(LocationSelected value)? locationSelected,
    TResult? Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult? Function(AnalysisFailed value)? analysisFailed,
    TResult? Function(SlowLoadingTriggered value)? slowLoadingTriggered,
  }) {
    return mapReset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapTapped value)? mapTapped,
    TResult Function(SearchToggled value)? searchToggled,
    TResult Function(ErrorCleared value)? errorCleared,
    TResult Function(MapReset value)? mapReset,
    TResult Function(LocationSelected value)? locationSelected,
    TResult Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult Function(AnalysisFailed value)? analysisFailed,
    TResult Function(SlowLoadingTriggered value)? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (mapReset != null) {
      return mapReset(this);
    }
    return orElse();
  }
}

abstract class MapReset implements MapEvent {
  const factory MapReset() = _$MapResetImpl;
}

/// @nodoc
abstract class _$$LocationSelectedImplCopyWith<$Res> {
  factory _$$LocationSelectedImplCopyWith(
    _$LocationSelectedImpl value,
    $Res Function(_$LocationSelectedImpl) then,
  ) = __$$LocationSelectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LatLng location, String addressName});
}

/// @nodoc
class __$$LocationSelectedImplCopyWithImpl<$Res>
    extends _$MapEventCopyWithImpl<$Res, _$LocationSelectedImpl>
    implements _$$LocationSelectedImplCopyWith<$Res> {
  __$$LocationSelectedImplCopyWithImpl(
    _$LocationSelectedImpl _value,
    $Res Function(_$LocationSelectedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? location = null, Object? addressName = null}) {
    return _then(
      _$LocationSelectedImpl(
        null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as LatLng,
        null == addressName
            ? _value.addressName
            : addressName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LocationSelectedImpl implements LocationSelected {
  const _$LocationSelectedImpl(this.location, this.addressName);

  @override
  final LatLng location;
  @override
  final String addressName;

  @override
  String toString() {
    return 'MapEvent.locationSelected(location: $location, addressName: $addressName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationSelectedImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.addressName, addressName) ||
                other.addressName == addressName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, addressName);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationSelectedImplCopyWith<_$LocationSelectedImpl> get copyWith =>
      __$$LocationSelectedImplCopyWithImpl<_$LocationSelectedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LatLng position) mapTapped,
    required TResult Function(bool show) searchToggled,
    required TResult Function() errorCleared,
    required TResult Function() mapReset,
    required TResult Function(LatLng location, String addressName)
    locationSelected,
    required TResult Function(LivabilityScore score, LatLng position)
    analysisSucceeded,
    required TResult Function(String errorMessage) analysisFailed,
    required TResult Function() slowLoadingTriggered,
  }) {
    return locationSelected(location, addressName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LatLng position)? mapTapped,
    TResult? Function(bool show)? searchToggled,
    TResult? Function()? errorCleared,
    TResult? Function()? mapReset,
    TResult? Function(LatLng location, String addressName)? locationSelected,
    TResult? Function(LivabilityScore score, LatLng position)?
    analysisSucceeded,
    TResult? Function(String errorMessage)? analysisFailed,
    TResult? Function()? slowLoadingTriggered,
  }) {
    return locationSelected?.call(location, addressName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LatLng position)? mapTapped,
    TResult Function(bool show)? searchToggled,
    TResult Function()? errorCleared,
    TResult Function()? mapReset,
    TResult Function(LatLng location, String addressName)? locationSelected,
    TResult Function(LivabilityScore score, LatLng position)? analysisSucceeded,
    TResult Function(String errorMessage)? analysisFailed,
    TResult Function()? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (locationSelected != null) {
      return locationSelected(location, addressName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapTapped value) mapTapped,
    required TResult Function(SearchToggled value) searchToggled,
    required TResult Function(ErrorCleared value) errorCleared,
    required TResult Function(MapReset value) mapReset,
    required TResult Function(LocationSelected value) locationSelected,
    required TResult Function(AnalysisSucceeded value) analysisSucceeded,
    required TResult Function(AnalysisFailed value) analysisFailed,
    required TResult Function(SlowLoadingTriggered value) slowLoadingTriggered,
  }) {
    return locationSelected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapTapped value)? mapTapped,
    TResult? Function(SearchToggled value)? searchToggled,
    TResult? Function(ErrorCleared value)? errorCleared,
    TResult? Function(MapReset value)? mapReset,
    TResult? Function(LocationSelected value)? locationSelected,
    TResult? Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult? Function(AnalysisFailed value)? analysisFailed,
    TResult? Function(SlowLoadingTriggered value)? slowLoadingTriggered,
  }) {
    return locationSelected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapTapped value)? mapTapped,
    TResult Function(SearchToggled value)? searchToggled,
    TResult Function(ErrorCleared value)? errorCleared,
    TResult Function(MapReset value)? mapReset,
    TResult Function(LocationSelected value)? locationSelected,
    TResult Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult Function(AnalysisFailed value)? analysisFailed,
    TResult Function(SlowLoadingTriggered value)? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (locationSelected != null) {
      return locationSelected(this);
    }
    return orElse();
  }
}

abstract class LocationSelected implements MapEvent {
  const factory LocationSelected(
    final LatLng location,
    final String addressName,
  ) = _$LocationSelectedImpl;

  LatLng get location;
  String get addressName;

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationSelectedImplCopyWith<_$LocationSelectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AnalysisSucceededImplCopyWith<$Res> {
  factory _$$AnalysisSucceededImplCopyWith(
    _$AnalysisSucceededImpl value,
    $Res Function(_$AnalysisSucceededImpl) then,
  ) = __$$AnalysisSucceededImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LivabilityScore score, LatLng position});

  $LivabilityScoreCopyWith<$Res> get score;
}

/// @nodoc
class __$$AnalysisSucceededImplCopyWithImpl<$Res>
    extends _$MapEventCopyWithImpl<$Res, _$AnalysisSucceededImpl>
    implements _$$AnalysisSucceededImplCopyWith<$Res> {
  __$$AnalysisSucceededImplCopyWithImpl(
    _$AnalysisSucceededImpl _value,
    $Res Function(_$AnalysisSucceededImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? score = null, Object? position = null}) {
    return _then(
      _$AnalysisSucceededImpl(
        null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as LivabilityScore,
        null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as LatLng,
      ),
    );
  }

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LivabilityScoreCopyWith<$Res> get score {
    return $LivabilityScoreCopyWith<$Res>(_value.score, (value) {
      return _then(_value.copyWith(score: value));
    });
  }
}

/// @nodoc

class _$AnalysisSucceededImpl implements AnalysisSucceeded {
  const _$AnalysisSucceededImpl(this.score, this.position);

  @override
  final LivabilityScore score;
  @override
  final LatLng position;

  @override
  String toString() {
    return 'MapEvent.analysisSucceeded(score: $score, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisSucceededImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @override
  int get hashCode => Object.hash(runtimeType, score, position);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisSucceededImplCopyWith<_$AnalysisSucceededImpl> get copyWith =>
      __$$AnalysisSucceededImplCopyWithImpl<_$AnalysisSucceededImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LatLng position) mapTapped,
    required TResult Function(bool show) searchToggled,
    required TResult Function() errorCleared,
    required TResult Function() mapReset,
    required TResult Function(LatLng location, String addressName)
    locationSelected,
    required TResult Function(LivabilityScore score, LatLng position)
    analysisSucceeded,
    required TResult Function(String errorMessage) analysisFailed,
    required TResult Function() slowLoadingTriggered,
  }) {
    return analysisSucceeded(score, position);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LatLng position)? mapTapped,
    TResult? Function(bool show)? searchToggled,
    TResult? Function()? errorCleared,
    TResult? Function()? mapReset,
    TResult? Function(LatLng location, String addressName)? locationSelected,
    TResult? Function(LivabilityScore score, LatLng position)?
    analysisSucceeded,
    TResult? Function(String errorMessage)? analysisFailed,
    TResult? Function()? slowLoadingTriggered,
  }) {
    return analysisSucceeded?.call(score, position);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LatLng position)? mapTapped,
    TResult Function(bool show)? searchToggled,
    TResult Function()? errorCleared,
    TResult Function()? mapReset,
    TResult Function(LatLng location, String addressName)? locationSelected,
    TResult Function(LivabilityScore score, LatLng position)? analysisSucceeded,
    TResult Function(String errorMessage)? analysisFailed,
    TResult Function()? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (analysisSucceeded != null) {
      return analysisSucceeded(score, position);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapTapped value) mapTapped,
    required TResult Function(SearchToggled value) searchToggled,
    required TResult Function(ErrorCleared value) errorCleared,
    required TResult Function(MapReset value) mapReset,
    required TResult Function(LocationSelected value) locationSelected,
    required TResult Function(AnalysisSucceeded value) analysisSucceeded,
    required TResult Function(AnalysisFailed value) analysisFailed,
    required TResult Function(SlowLoadingTriggered value) slowLoadingTriggered,
  }) {
    return analysisSucceeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapTapped value)? mapTapped,
    TResult? Function(SearchToggled value)? searchToggled,
    TResult? Function(ErrorCleared value)? errorCleared,
    TResult? Function(MapReset value)? mapReset,
    TResult? Function(LocationSelected value)? locationSelected,
    TResult? Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult? Function(AnalysisFailed value)? analysisFailed,
    TResult? Function(SlowLoadingTriggered value)? slowLoadingTriggered,
  }) {
    return analysisSucceeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapTapped value)? mapTapped,
    TResult Function(SearchToggled value)? searchToggled,
    TResult Function(ErrorCleared value)? errorCleared,
    TResult Function(MapReset value)? mapReset,
    TResult Function(LocationSelected value)? locationSelected,
    TResult Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult Function(AnalysisFailed value)? analysisFailed,
    TResult Function(SlowLoadingTriggered value)? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (analysisSucceeded != null) {
      return analysisSucceeded(this);
    }
    return orElse();
  }
}

abstract class AnalysisSucceeded implements MapEvent {
  const factory AnalysisSucceeded(
    final LivabilityScore score,
    final LatLng position,
  ) = _$AnalysisSucceededImpl;

  LivabilityScore get score;
  LatLng get position;

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisSucceededImplCopyWith<_$AnalysisSucceededImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AnalysisFailedImplCopyWith<$Res> {
  factory _$$AnalysisFailedImplCopyWith(
    _$AnalysisFailedImpl value,
    $Res Function(_$AnalysisFailedImpl) then,
  ) = __$$AnalysisFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class __$$AnalysisFailedImplCopyWithImpl<$Res>
    extends _$MapEventCopyWithImpl<$Res, _$AnalysisFailedImpl>
    implements _$$AnalysisFailedImplCopyWith<$Res> {
  __$$AnalysisFailedImplCopyWithImpl(
    _$AnalysisFailedImpl _value,
    $Res Function(_$AnalysisFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? errorMessage = null}) {
    return _then(
      _$AnalysisFailedImpl(
        null == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AnalysisFailedImpl implements AnalysisFailed {
  const _$AnalysisFailedImpl(this.errorMessage);

  @override
  final String errorMessage;

  @override
  String toString() {
    return 'MapEvent.analysisFailed(errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisFailedImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisFailedImplCopyWith<_$AnalysisFailedImpl> get copyWith =>
      __$$AnalysisFailedImplCopyWithImpl<_$AnalysisFailedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LatLng position) mapTapped,
    required TResult Function(bool show) searchToggled,
    required TResult Function() errorCleared,
    required TResult Function() mapReset,
    required TResult Function(LatLng location, String addressName)
    locationSelected,
    required TResult Function(LivabilityScore score, LatLng position)
    analysisSucceeded,
    required TResult Function(String errorMessage) analysisFailed,
    required TResult Function() slowLoadingTriggered,
  }) {
    return analysisFailed(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LatLng position)? mapTapped,
    TResult? Function(bool show)? searchToggled,
    TResult? Function()? errorCleared,
    TResult? Function()? mapReset,
    TResult? Function(LatLng location, String addressName)? locationSelected,
    TResult? Function(LivabilityScore score, LatLng position)?
    analysisSucceeded,
    TResult? Function(String errorMessage)? analysisFailed,
    TResult? Function()? slowLoadingTriggered,
  }) {
    return analysisFailed?.call(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LatLng position)? mapTapped,
    TResult Function(bool show)? searchToggled,
    TResult Function()? errorCleared,
    TResult Function()? mapReset,
    TResult Function(LatLng location, String addressName)? locationSelected,
    TResult Function(LivabilityScore score, LatLng position)? analysisSucceeded,
    TResult Function(String errorMessage)? analysisFailed,
    TResult Function()? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (analysisFailed != null) {
      return analysisFailed(errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapTapped value) mapTapped,
    required TResult Function(SearchToggled value) searchToggled,
    required TResult Function(ErrorCleared value) errorCleared,
    required TResult Function(MapReset value) mapReset,
    required TResult Function(LocationSelected value) locationSelected,
    required TResult Function(AnalysisSucceeded value) analysisSucceeded,
    required TResult Function(AnalysisFailed value) analysisFailed,
    required TResult Function(SlowLoadingTriggered value) slowLoadingTriggered,
  }) {
    return analysisFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapTapped value)? mapTapped,
    TResult? Function(SearchToggled value)? searchToggled,
    TResult? Function(ErrorCleared value)? errorCleared,
    TResult? Function(MapReset value)? mapReset,
    TResult? Function(LocationSelected value)? locationSelected,
    TResult? Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult? Function(AnalysisFailed value)? analysisFailed,
    TResult? Function(SlowLoadingTriggered value)? slowLoadingTriggered,
  }) {
    return analysisFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapTapped value)? mapTapped,
    TResult Function(SearchToggled value)? searchToggled,
    TResult Function(ErrorCleared value)? errorCleared,
    TResult Function(MapReset value)? mapReset,
    TResult Function(LocationSelected value)? locationSelected,
    TResult Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult Function(AnalysisFailed value)? analysisFailed,
    TResult Function(SlowLoadingTriggered value)? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (analysisFailed != null) {
      return analysisFailed(this);
    }
    return orElse();
  }
}

abstract class AnalysisFailed implements MapEvent {
  const factory AnalysisFailed(final String errorMessage) =
      _$AnalysisFailedImpl;

  String get errorMessage;

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisFailedImplCopyWith<_$AnalysisFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SlowLoadingTriggeredImplCopyWith<$Res> {
  factory _$$SlowLoadingTriggeredImplCopyWith(
    _$SlowLoadingTriggeredImpl value,
    $Res Function(_$SlowLoadingTriggeredImpl) then,
  ) = __$$SlowLoadingTriggeredImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SlowLoadingTriggeredImplCopyWithImpl<$Res>
    extends _$MapEventCopyWithImpl<$Res, _$SlowLoadingTriggeredImpl>
    implements _$$SlowLoadingTriggeredImplCopyWith<$Res> {
  __$$SlowLoadingTriggeredImplCopyWithImpl(
    _$SlowLoadingTriggeredImpl _value,
    $Res Function(_$SlowLoadingTriggeredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SlowLoadingTriggeredImpl implements SlowLoadingTriggered {
  const _$SlowLoadingTriggeredImpl();

  @override
  String toString() {
    return 'MapEvent.slowLoadingTriggered()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SlowLoadingTriggeredImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LatLng position) mapTapped,
    required TResult Function(bool show) searchToggled,
    required TResult Function() errorCleared,
    required TResult Function() mapReset,
    required TResult Function(LatLng location, String addressName)
    locationSelected,
    required TResult Function(LivabilityScore score, LatLng position)
    analysisSucceeded,
    required TResult Function(String errorMessage) analysisFailed,
    required TResult Function() slowLoadingTriggered,
  }) {
    return slowLoadingTriggered();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LatLng position)? mapTapped,
    TResult? Function(bool show)? searchToggled,
    TResult? Function()? errorCleared,
    TResult? Function()? mapReset,
    TResult? Function(LatLng location, String addressName)? locationSelected,
    TResult? Function(LivabilityScore score, LatLng position)?
    analysisSucceeded,
    TResult? Function(String errorMessage)? analysisFailed,
    TResult? Function()? slowLoadingTriggered,
  }) {
    return slowLoadingTriggered?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LatLng position)? mapTapped,
    TResult Function(bool show)? searchToggled,
    TResult Function()? errorCleared,
    TResult Function()? mapReset,
    TResult Function(LatLng location, String addressName)? locationSelected,
    TResult Function(LivabilityScore score, LatLng position)? analysisSucceeded,
    TResult Function(String errorMessage)? analysisFailed,
    TResult Function()? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (slowLoadingTriggered != null) {
      return slowLoadingTriggered();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapTapped value) mapTapped,
    required TResult Function(SearchToggled value) searchToggled,
    required TResult Function(ErrorCleared value) errorCleared,
    required TResult Function(MapReset value) mapReset,
    required TResult Function(LocationSelected value) locationSelected,
    required TResult Function(AnalysisSucceeded value) analysisSucceeded,
    required TResult Function(AnalysisFailed value) analysisFailed,
    required TResult Function(SlowLoadingTriggered value) slowLoadingTriggered,
  }) {
    return slowLoadingTriggered(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapTapped value)? mapTapped,
    TResult? Function(SearchToggled value)? searchToggled,
    TResult? Function(ErrorCleared value)? errorCleared,
    TResult? Function(MapReset value)? mapReset,
    TResult? Function(LocationSelected value)? locationSelected,
    TResult? Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult? Function(AnalysisFailed value)? analysisFailed,
    TResult? Function(SlowLoadingTriggered value)? slowLoadingTriggered,
  }) {
    return slowLoadingTriggered?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapTapped value)? mapTapped,
    TResult Function(SearchToggled value)? searchToggled,
    TResult Function(ErrorCleared value)? errorCleared,
    TResult Function(MapReset value)? mapReset,
    TResult Function(LocationSelected value)? locationSelected,
    TResult Function(AnalysisSucceeded value)? analysisSucceeded,
    TResult Function(AnalysisFailed value)? analysisFailed,
    TResult Function(SlowLoadingTriggered value)? slowLoadingTriggered,
    required TResult orElse(),
  }) {
    if (slowLoadingTriggered != null) {
      return slowLoadingTriggered(this);
    }
    return orElse();
  }
}

abstract class SlowLoadingTriggered implements MapEvent {
  const factory SlowLoadingTriggered() = _$SlowLoadingTriggeredImpl;
}

/// @nodoc
mixin _$MapState {
  LocationMarker? get selectedMarker => throw _privateConstructorUsedError;
  LivabilityScore? get currentScore => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  bool get showSearch => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  bool get showSlowLoadingMessage => throw _privateConstructorUsedError;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapStateCopyWith<MapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapStateCopyWith<$Res> {
  factory $MapStateCopyWith(MapState value, $Res Function(MapState) then) =
      _$MapStateCopyWithImpl<$Res, MapState>;
  @useResult
  $Res call({
    LocationMarker? selectedMarker,
    LivabilityScore? currentScore,
    bool isLoading,
    String? errorMessage,
    bool showSearch,
    String searchQuery,
    bool showSlowLoadingMessage,
  });

  $LocationMarkerCopyWith<$Res>? get selectedMarker;
  $LivabilityScoreCopyWith<$Res>? get currentScore;
}

/// @nodoc
class _$MapStateCopyWithImpl<$Res, $Val extends MapState>
    implements $MapStateCopyWith<$Res> {
  _$MapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedMarker = freezed,
    Object? currentScore = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? showSearch = null,
    Object? searchQuery = null,
    Object? showSlowLoadingMessage = null,
  }) {
    return _then(
      _value.copyWith(
            selectedMarker: freezed == selectedMarker
                ? _value.selectedMarker
                : selectedMarker // ignore: cast_nullable_to_non_nullable
                      as LocationMarker?,
            currentScore: freezed == currentScore
                ? _value.currentScore
                : currentScore // ignore: cast_nullable_to_non_nullable
                      as LivabilityScore?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            showSearch: null == showSearch
                ? _value.showSearch
                : showSearch // ignore: cast_nullable_to_non_nullable
                      as bool,
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            showSlowLoadingMessage: null == showSlowLoadingMessage
                ? _value.showSlowLoadingMessage
                : showSlowLoadingMessage // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationMarkerCopyWith<$Res>? get selectedMarker {
    if (_value.selectedMarker == null) {
      return null;
    }

    return $LocationMarkerCopyWith<$Res>(_value.selectedMarker!, (value) {
      return _then(_value.copyWith(selectedMarker: value) as $Val);
    });
  }

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LivabilityScoreCopyWith<$Res>? get currentScore {
    if (_value.currentScore == null) {
      return null;
    }

    return $LivabilityScoreCopyWith<$Res>(_value.currentScore!, (value) {
      return _then(_value.copyWith(currentScore: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MapStateImplCopyWith<$Res>
    implements $MapStateCopyWith<$Res> {
  factory _$$MapStateImplCopyWith(
    _$MapStateImpl value,
    $Res Function(_$MapStateImpl) then,
  ) = __$$MapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LocationMarker? selectedMarker,
    LivabilityScore? currentScore,
    bool isLoading,
    String? errorMessage,
    bool showSearch,
    String searchQuery,
    bool showSlowLoadingMessage,
  });

  @override
  $LocationMarkerCopyWith<$Res>? get selectedMarker;
  @override
  $LivabilityScoreCopyWith<$Res>? get currentScore;
}

/// @nodoc
class __$$MapStateImplCopyWithImpl<$Res>
    extends _$MapStateCopyWithImpl<$Res, _$MapStateImpl>
    implements _$$MapStateImplCopyWith<$Res> {
  __$$MapStateImplCopyWithImpl(
    _$MapStateImpl _value,
    $Res Function(_$MapStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedMarker = freezed,
    Object? currentScore = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? showSearch = null,
    Object? searchQuery = null,
    Object? showSlowLoadingMessage = null,
  }) {
    return _then(
      _$MapStateImpl(
        selectedMarker: freezed == selectedMarker
            ? _value.selectedMarker
            : selectedMarker // ignore: cast_nullable_to_non_nullable
                  as LocationMarker?,
        currentScore: freezed == currentScore
            ? _value.currentScore
            : currentScore // ignore: cast_nullable_to_non_nullable
                  as LivabilityScore?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        showSearch: null == showSearch
            ? _value.showSearch
            : showSearch // ignore: cast_nullable_to_non_nullable
                  as bool,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        showSlowLoadingMessage: null == showSlowLoadingMessage
            ? _value.showSlowLoadingMessage
            : showSlowLoadingMessage // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$MapStateImpl implements _MapState {
  const _$MapStateImpl({
    this.selectedMarker,
    this.currentScore,
    this.isLoading = false,
    this.errorMessage,
    this.showSearch = false,
    this.searchQuery = '',
    this.showSlowLoadingMessage = false,
  });

  @override
  final LocationMarker? selectedMarker;
  @override
  final LivabilityScore? currentScore;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool showSearch;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final bool showSlowLoadingMessage;

  @override
  String toString() {
    return 'MapState(selectedMarker: $selectedMarker, currentScore: $currentScore, isLoading: $isLoading, errorMessage: $errorMessage, showSearch: $showSearch, searchQuery: $searchQuery, showSlowLoadingMessage: $showSlowLoadingMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapStateImpl &&
            (identical(other.selectedMarker, selectedMarker) ||
                other.selectedMarker == selectedMarker) &&
            (identical(other.currentScore, currentScore) ||
                other.currentScore == currentScore) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.showSearch, showSearch) ||
                other.showSearch == showSearch) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.showSlowLoadingMessage, showSlowLoadingMessage) ||
                other.showSlowLoadingMessage == showSlowLoadingMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedMarker,
    currentScore,
    isLoading,
    errorMessage,
    showSearch,
    searchQuery,
    showSlowLoadingMessage,
  );

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapStateImplCopyWith<_$MapStateImpl> get copyWith =>
      __$$MapStateImplCopyWithImpl<_$MapStateImpl>(this, _$identity);
}

abstract class _MapState implements MapState {
  const factory _MapState({
    final LocationMarker? selectedMarker,
    final LivabilityScore? currentScore,
    final bool isLoading,
    final String? errorMessage,
    final bool showSearch,
    final String searchQuery,
    final bool showSlowLoadingMessage,
  }) = _$MapStateImpl;

  @override
  LocationMarker? get selectedMarker;
  @override
  LivabilityScore? get currentScore;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  bool get showSearch;
  @override
  String get searchQuery;
  @override
  bool get showSlowLoadingMessage;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapStateImplCopyWith<_$MapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
