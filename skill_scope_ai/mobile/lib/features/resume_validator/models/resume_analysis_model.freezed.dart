// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resume_analysis_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResumeAnalysis {

 String get jobRole; int get matchScore; List<String> get detectedSkills; List<String> get missingSkills; List<LearningResource> get recommendedResources;
/// Create a copy of ResumeAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeAnalysisCopyWith<ResumeAnalysis> get copyWith => _$ResumeAnalysisCopyWithImpl<ResumeAnalysis>(this as ResumeAnalysis, _$identity);

  /// Serializes this ResumeAnalysis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeAnalysis&&(identical(other.jobRole, jobRole) || other.jobRole == jobRole)&&(identical(other.matchScore, matchScore) || other.matchScore == matchScore)&&const DeepCollectionEquality().equals(other.detectedSkills, detectedSkills)&&const DeepCollectionEquality().equals(other.missingSkills, missingSkills)&&const DeepCollectionEquality().equals(other.recommendedResources, recommendedResources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobRole,matchScore,const DeepCollectionEquality().hash(detectedSkills),const DeepCollectionEquality().hash(missingSkills),const DeepCollectionEquality().hash(recommendedResources));

@override
String toString() {
  return 'ResumeAnalysis(jobRole: $jobRole, matchScore: $matchScore, detectedSkills: $detectedSkills, missingSkills: $missingSkills, recommendedResources: $recommendedResources)';
}


}

/// @nodoc
abstract mixin class $ResumeAnalysisCopyWith<$Res>  {
  factory $ResumeAnalysisCopyWith(ResumeAnalysis value, $Res Function(ResumeAnalysis) _then) = _$ResumeAnalysisCopyWithImpl;
@useResult
$Res call({
 String jobRole, int matchScore, List<String> detectedSkills, List<String> missingSkills, List<LearningResource> recommendedResources
});




}
/// @nodoc
class _$ResumeAnalysisCopyWithImpl<$Res>
    implements $ResumeAnalysisCopyWith<$Res> {
  _$ResumeAnalysisCopyWithImpl(this._self, this._then);

  final ResumeAnalysis _self;
  final $Res Function(ResumeAnalysis) _then;

/// Create a copy of ResumeAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobRole = null,Object? matchScore = null,Object? detectedSkills = null,Object? missingSkills = null,Object? recommendedResources = null,}) {
  return _then(_self.copyWith(
jobRole: null == jobRole ? _self.jobRole : jobRole // ignore: cast_nullable_to_non_nullable
as String,matchScore: null == matchScore ? _self.matchScore : matchScore // ignore: cast_nullable_to_non_nullable
as int,detectedSkills: null == detectedSkills ? _self.detectedSkills : detectedSkills // ignore: cast_nullable_to_non_nullable
as List<String>,missingSkills: null == missingSkills ? _self.missingSkills : missingSkills // ignore: cast_nullable_to_non_nullable
as List<String>,recommendedResources: null == recommendedResources ? _self.recommendedResources : recommendedResources // ignore: cast_nullable_to_non_nullable
as List<LearningResource>,
  ));
}

}


/// Adds pattern-matching-related methods to [ResumeAnalysis].
extension ResumeAnalysisPatterns on ResumeAnalysis {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResumeAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResumeAnalysis() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResumeAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _ResumeAnalysis():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResumeAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _ResumeAnalysis() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jobRole,  int matchScore,  List<String> detectedSkills,  List<String> missingSkills,  List<LearningResource> recommendedResources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResumeAnalysis() when $default != null:
return $default(_that.jobRole,_that.matchScore,_that.detectedSkills,_that.missingSkills,_that.recommendedResources);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jobRole,  int matchScore,  List<String> detectedSkills,  List<String> missingSkills,  List<LearningResource> recommendedResources)  $default,) {final _that = this;
switch (_that) {
case _ResumeAnalysis():
return $default(_that.jobRole,_that.matchScore,_that.detectedSkills,_that.missingSkills,_that.recommendedResources);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jobRole,  int matchScore,  List<String> detectedSkills,  List<String> missingSkills,  List<LearningResource> recommendedResources)?  $default,) {final _that = this;
switch (_that) {
case _ResumeAnalysis() when $default != null:
return $default(_that.jobRole,_that.matchScore,_that.detectedSkills,_that.missingSkills,_that.recommendedResources);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResumeAnalysis implements ResumeAnalysis {
  const _ResumeAnalysis({required this.jobRole, required this.matchScore, final  List<String> detectedSkills = const [], final  List<String> missingSkills = const [], final  List<LearningResource> recommendedResources = const []}): _detectedSkills = detectedSkills,_missingSkills = missingSkills,_recommendedResources = recommendedResources;
  factory _ResumeAnalysis.fromJson(Map<String, dynamic> json) => _$ResumeAnalysisFromJson(json);

@override final  String jobRole;
@override final  int matchScore;
 final  List<String> _detectedSkills;
@override@JsonKey() List<String> get detectedSkills {
  if (_detectedSkills is EqualUnmodifiableListView) return _detectedSkills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_detectedSkills);
}

 final  List<String> _missingSkills;
@override@JsonKey() List<String> get missingSkills {
  if (_missingSkills is EqualUnmodifiableListView) return _missingSkills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missingSkills);
}

 final  List<LearningResource> _recommendedResources;
@override@JsonKey() List<LearningResource> get recommendedResources {
  if (_recommendedResources is EqualUnmodifiableListView) return _recommendedResources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendedResources);
}


/// Create a copy of ResumeAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResumeAnalysisCopyWith<_ResumeAnalysis> get copyWith => __$ResumeAnalysisCopyWithImpl<_ResumeAnalysis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResumeAnalysisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResumeAnalysis&&(identical(other.jobRole, jobRole) || other.jobRole == jobRole)&&(identical(other.matchScore, matchScore) || other.matchScore == matchScore)&&const DeepCollectionEquality().equals(other._detectedSkills, _detectedSkills)&&const DeepCollectionEquality().equals(other._missingSkills, _missingSkills)&&const DeepCollectionEquality().equals(other._recommendedResources, _recommendedResources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobRole,matchScore,const DeepCollectionEquality().hash(_detectedSkills),const DeepCollectionEquality().hash(_missingSkills),const DeepCollectionEquality().hash(_recommendedResources));

@override
String toString() {
  return 'ResumeAnalysis(jobRole: $jobRole, matchScore: $matchScore, detectedSkills: $detectedSkills, missingSkills: $missingSkills, recommendedResources: $recommendedResources)';
}


}

/// @nodoc
abstract mixin class _$ResumeAnalysisCopyWith<$Res> implements $ResumeAnalysisCopyWith<$Res> {
  factory _$ResumeAnalysisCopyWith(_ResumeAnalysis value, $Res Function(_ResumeAnalysis) _then) = __$ResumeAnalysisCopyWithImpl;
@override @useResult
$Res call({
 String jobRole, int matchScore, List<String> detectedSkills, List<String> missingSkills, List<LearningResource> recommendedResources
});




}
/// @nodoc
class __$ResumeAnalysisCopyWithImpl<$Res>
    implements _$ResumeAnalysisCopyWith<$Res> {
  __$ResumeAnalysisCopyWithImpl(this._self, this._then);

  final _ResumeAnalysis _self;
  final $Res Function(_ResumeAnalysis) _then;

/// Create a copy of ResumeAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobRole = null,Object? matchScore = null,Object? detectedSkills = null,Object? missingSkills = null,Object? recommendedResources = null,}) {
  return _then(_ResumeAnalysis(
jobRole: null == jobRole ? _self.jobRole : jobRole // ignore: cast_nullable_to_non_nullable
as String,matchScore: null == matchScore ? _self.matchScore : matchScore // ignore: cast_nullable_to_non_nullable
as int,detectedSkills: null == detectedSkills ? _self._detectedSkills : detectedSkills // ignore: cast_nullable_to_non_nullable
as List<String>,missingSkills: null == missingSkills ? _self._missingSkills : missingSkills // ignore: cast_nullable_to_non_nullable
as List<String>,recommendedResources: null == recommendedResources ? _self._recommendedResources : recommendedResources // ignore: cast_nullable_to_non_nullable
as List<LearningResource>,
  ));
}


}


/// @nodoc
mixin _$LearningResource {

 String get title; String get url; String? get description; String? get platform;
/// Create a copy of LearningResource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningResourceCopyWith<LearningResource> get copyWith => _$LearningResourceCopyWithImpl<LearningResource>(this as LearningResource, _$identity);

  /// Serializes this LearningResource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningResource&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.description, description) || other.description == description)&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,url,description,platform);

@override
String toString() {
  return 'LearningResource(title: $title, url: $url, description: $description, platform: $platform)';
}


}

/// @nodoc
abstract mixin class $LearningResourceCopyWith<$Res>  {
  factory $LearningResourceCopyWith(LearningResource value, $Res Function(LearningResource) _then) = _$LearningResourceCopyWithImpl;
@useResult
$Res call({
 String title, String url, String? description, String? platform
});




}
/// @nodoc
class _$LearningResourceCopyWithImpl<$Res>
    implements $LearningResourceCopyWith<$Res> {
  _$LearningResourceCopyWithImpl(this._self, this._then);

  final LearningResource _self;
  final $Res Function(LearningResource) _then;

/// Create a copy of LearningResource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? url = null,Object? description = freezed,Object? platform = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LearningResource].
extension LearningResourcePatterns on LearningResource {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearningResource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearningResource() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearningResource value)  $default,){
final _that = this;
switch (_that) {
case _LearningResource():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearningResource value)?  $default,){
final _that = this;
switch (_that) {
case _LearningResource() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String url,  String? description,  String? platform)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearningResource() when $default != null:
return $default(_that.title,_that.url,_that.description,_that.platform);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String url,  String? description,  String? platform)  $default,) {final _that = this;
switch (_that) {
case _LearningResource():
return $default(_that.title,_that.url,_that.description,_that.platform);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String url,  String? description,  String? platform)?  $default,) {final _that = this;
switch (_that) {
case _LearningResource() when $default != null:
return $default(_that.title,_that.url,_that.description,_that.platform);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LearningResource implements LearningResource {
  const _LearningResource({required this.title, required this.url, this.description, this.platform});
  factory _LearningResource.fromJson(Map<String, dynamic> json) => _$LearningResourceFromJson(json);

@override final  String title;
@override final  String url;
@override final  String? description;
@override final  String? platform;

/// Create a copy of LearningResource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningResourceCopyWith<_LearningResource> get copyWith => __$LearningResourceCopyWithImpl<_LearningResource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearningResourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningResource&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.description, description) || other.description == description)&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,url,description,platform);

@override
String toString() {
  return 'LearningResource(title: $title, url: $url, description: $description, platform: $platform)';
}


}

/// @nodoc
abstract mixin class _$LearningResourceCopyWith<$Res> implements $LearningResourceCopyWith<$Res> {
  factory _$LearningResourceCopyWith(_LearningResource value, $Res Function(_LearningResource) _then) = __$LearningResourceCopyWithImpl;
@override @useResult
$Res call({
 String title, String url, String? description, String? platform
});




}
/// @nodoc
class __$LearningResourceCopyWithImpl<$Res>
    implements _$LearningResourceCopyWith<$Res> {
  __$LearningResourceCopyWithImpl(this._self, this._then);

  final _LearningResource _self;
  final $Res Function(_LearningResource) _then;

/// Create a copy of LearningResource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? url = null,Object? description = freezed,Object? platform = freezed,}) {
  return _then(_LearningResource(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ResumeUploadRequest {

 String get jobRole; String get resumeFilePath; String get fileType;
/// Create a copy of ResumeUploadRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeUploadRequestCopyWith<ResumeUploadRequest> get copyWith => _$ResumeUploadRequestCopyWithImpl<ResumeUploadRequest>(this as ResumeUploadRequest, _$identity);

  /// Serializes this ResumeUploadRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeUploadRequest&&(identical(other.jobRole, jobRole) || other.jobRole == jobRole)&&(identical(other.resumeFilePath, resumeFilePath) || other.resumeFilePath == resumeFilePath)&&(identical(other.fileType, fileType) || other.fileType == fileType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobRole,resumeFilePath,fileType);

@override
String toString() {
  return 'ResumeUploadRequest(jobRole: $jobRole, resumeFilePath: $resumeFilePath, fileType: $fileType)';
}


}

/// @nodoc
abstract mixin class $ResumeUploadRequestCopyWith<$Res>  {
  factory $ResumeUploadRequestCopyWith(ResumeUploadRequest value, $Res Function(ResumeUploadRequest) _then) = _$ResumeUploadRequestCopyWithImpl;
@useResult
$Res call({
 String jobRole, String resumeFilePath, String fileType
});




}
/// @nodoc
class _$ResumeUploadRequestCopyWithImpl<$Res>
    implements $ResumeUploadRequestCopyWith<$Res> {
  _$ResumeUploadRequestCopyWithImpl(this._self, this._then);

  final ResumeUploadRequest _self;
  final $Res Function(ResumeUploadRequest) _then;

/// Create a copy of ResumeUploadRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobRole = null,Object? resumeFilePath = null,Object? fileType = null,}) {
  return _then(_self.copyWith(
jobRole: null == jobRole ? _self.jobRole : jobRole // ignore: cast_nullable_to_non_nullable
as String,resumeFilePath: null == resumeFilePath ? _self.resumeFilePath : resumeFilePath // ignore: cast_nullable_to_non_nullable
as String,fileType: null == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ResumeUploadRequest].
extension ResumeUploadRequestPatterns on ResumeUploadRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResumeUploadRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResumeUploadRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResumeUploadRequest value)  $default,){
final _that = this;
switch (_that) {
case _ResumeUploadRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResumeUploadRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ResumeUploadRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jobRole,  String resumeFilePath,  String fileType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResumeUploadRequest() when $default != null:
return $default(_that.jobRole,_that.resumeFilePath,_that.fileType);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jobRole,  String resumeFilePath,  String fileType)  $default,) {final _that = this;
switch (_that) {
case _ResumeUploadRequest():
return $default(_that.jobRole,_that.resumeFilePath,_that.fileType);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jobRole,  String resumeFilePath,  String fileType)?  $default,) {final _that = this;
switch (_that) {
case _ResumeUploadRequest() when $default != null:
return $default(_that.jobRole,_that.resumeFilePath,_that.fileType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResumeUploadRequest implements ResumeUploadRequest {
  const _ResumeUploadRequest({required this.jobRole, required this.resumeFilePath, required this.fileType});
  factory _ResumeUploadRequest.fromJson(Map<String, dynamic> json) => _$ResumeUploadRequestFromJson(json);

@override final  String jobRole;
@override final  String resumeFilePath;
@override final  String fileType;

/// Create a copy of ResumeUploadRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResumeUploadRequestCopyWith<_ResumeUploadRequest> get copyWith => __$ResumeUploadRequestCopyWithImpl<_ResumeUploadRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResumeUploadRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResumeUploadRequest&&(identical(other.jobRole, jobRole) || other.jobRole == jobRole)&&(identical(other.resumeFilePath, resumeFilePath) || other.resumeFilePath == resumeFilePath)&&(identical(other.fileType, fileType) || other.fileType == fileType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobRole,resumeFilePath,fileType);

@override
String toString() {
  return 'ResumeUploadRequest(jobRole: $jobRole, resumeFilePath: $resumeFilePath, fileType: $fileType)';
}


}

/// @nodoc
abstract mixin class _$ResumeUploadRequestCopyWith<$Res> implements $ResumeUploadRequestCopyWith<$Res> {
  factory _$ResumeUploadRequestCopyWith(_ResumeUploadRequest value, $Res Function(_ResumeUploadRequest) _then) = __$ResumeUploadRequestCopyWithImpl;
@override @useResult
$Res call({
 String jobRole, String resumeFilePath, String fileType
});




}
/// @nodoc
class __$ResumeUploadRequestCopyWithImpl<$Res>
    implements _$ResumeUploadRequestCopyWith<$Res> {
  __$ResumeUploadRequestCopyWithImpl(this._self, this._then);

  final _ResumeUploadRequest _self;
  final $Res Function(_ResumeUploadRequest) _then;

/// Create a copy of ResumeUploadRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobRole = null,Object? resumeFilePath = null,Object? fileType = null,}) {
  return _then(_ResumeUploadRequest(
jobRole: null == jobRole ? _self.jobRole : jobRole // ignore: cast_nullable_to_non_nullable
as String,resumeFilePath: null == resumeFilePath ? _self.resumeFilePath : resumeFilePath // ignore: cast_nullable_to_non_nullable
as String,fileType: null == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$JobRoleSkills {

 String get role; List<String> get skills;
/// Create a copy of JobRoleSkills
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobRoleSkillsCopyWith<JobRoleSkills> get copyWith => _$JobRoleSkillsCopyWithImpl<JobRoleSkills>(this as JobRoleSkills, _$identity);

  /// Serializes this JobRoleSkills to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobRoleSkills&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.skills, skills));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,const DeepCollectionEquality().hash(skills));

@override
String toString() {
  return 'JobRoleSkills(role: $role, skills: $skills)';
}


}

/// @nodoc
abstract mixin class $JobRoleSkillsCopyWith<$Res>  {
  factory $JobRoleSkillsCopyWith(JobRoleSkills value, $Res Function(JobRoleSkills) _then) = _$JobRoleSkillsCopyWithImpl;
@useResult
$Res call({
 String role, List<String> skills
});




}
/// @nodoc
class _$JobRoleSkillsCopyWithImpl<$Res>
    implements $JobRoleSkillsCopyWith<$Res> {
  _$JobRoleSkillsCopyWithImpl(this._self, this._then);

  final JobRoleSkills _self;
  final $Res Function(JobRoleSkills) _then;

/// Create a copy of JobRoleSkills
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? skills = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [JobRoleSkills].
extension JobRoleSkillsPatterns on JobRoleSkills {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobRoleSkills value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobRoleSkills() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobRoleSkills value)  $default,){
final _that = this;
switch (_that) {
case _JobRoleSkills():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobRoleSkills value)?  $default,){
final _that = this;
switch (_that) {
case _JobRoleSkills() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  List<String> skills)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobRoleSkills() when $default != null:
return $default(_that.role,_that.skills);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  List<String> skills)  $default,) {final _that = this;
switch (_that) {
case _JobRoleSkills():
return $default(_that.role,_that.skills);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  List<String> skills)?  $default,) {final _that = this;
switch (_that) {
case _JobRoleSkills() when $default != null:
return $default(_that.role,_that.skills);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobRoleSkills implements JobRoleSkills {
  const _JobRoleSkills({required this.role, final  List<String> skills = const []}): _skills = skills;
  factory _JobRoleSkills.fromJson(Map<String, dynamic> json) => _$JobRoleSkillsFromJson(json);

@override final  String role;
 final  List<String> _skills;
@override@JsonKey() List<String> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}


/// Create a copy of JobRoleSkills
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobRoleSkillsCopyWith<_JobRoleSkills> get copyWith => __$JobRoleSkillsCopyWithImpl<_JobRoleSkills>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobRoleSkillsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobRoleSkills&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other._skills, _skills));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,const DeepCollectionEquality().hash(_skills));

@override
String toString() {
  return 'JobRoleSkills(role: $role, skills: $skills)';
}


}

/// @nodoc
abstract mixin class _$JobRoleSkillsCopyWith<$Res> implements $JobRoleSkillsCopyWith<$Res> {
  factory _$JobRoleSkillsCopyWith(_JobRoleSkills value, $Res Function(_JobRoleSkills) _then) = __$JobRoleSkillsCopyWithImpl;
@override @useResult
$Res call({
 String role, List<String> skills
});




}
/// @nodoc
class __$JobRoleSkillsCopyWithImpl<$Res>
    implements _$JobRoleSkillsCopyWith<$Res> {
  __$JobRoleSkillsCopyWithImpl(this._self, this._then);

  final _JobRoleSkills _self;
  final $Res Function(_JobRoleSkills) _then;

/// Create a copy of JobRoleSkills
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? skills = null,}) {
  return _then(_JobRoleSkills(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
