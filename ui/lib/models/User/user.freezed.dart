// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

@JsonKey(name: '_id', includeIfNull: false) String? get id;@JsonKey(name: 'userName') String get userName;@JsonKey(name: 'email') String get email;@JsonKey(name: 'fullName') String get fullName;@JsonKey(name: 'avatar') String get avatar;@JsonKey(name: 'coverImage') String get coverImage;@JsonKey(name: 'watchHistory') List<dynamic> get watchHistory;@JsonKey(name: 'password') String get password;@JsonKey(name: 'accessToken', includeIfNull: false) String? get accessToken;@JsonKey(name: 'refreshToken', includeIfNull: false) String? get refreshToken;@JsonKey(name: 'createdAt') String get createdAt;@JsonKey(name: 'updatedAt') String get updatedAt;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&const DeepCollectionEquality().equals(other.watchHistory, watchHistory)&&(identical(other.password, password) || other.password == password)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userName,email,fullName,avatar,coverImage,const DeepCollectionEquality().hash(watchHistory),password,accessToken,refreshToken,createdAt,updatedAt);

@override
String toString() {
  return 'User(id: $id, userName: $userName, email: $email, fullName: $fullName, avatar: $avatar, coverImage: $coverImage, watchHistory: $watchHistory, password: $password, accessToken: $accessToken, refreshToken: $refreshToken, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id', includeIfNull: false) String? id,@JsonKey(name: 'userName') String userName,@JsonKey(name: 'email') String email,@JsonKey(name: 'fullName') String fullName,@JsonKey(name: 'avatar') String avatar,@JsonKey(name: 'coverImage') String coverImage,@JsonKey(name: 'watchHistory') List<dynamic> watchHistory,@JsonKey(name: 'password') String password,@JsonKey(name: 'accessToken', includeIfNull: false) String? accessToken,@JsonKey(name: 'refreshToken', includeIfNull: false) String? refreshToken,@JsonKey(name: 'createdAt') String createdAt,@JsonKey(name: 'updatedAt') String updatedAt
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userName = null,Object? email = null,Object? fullName = null,Object? avatar = null,Object? coverImage = null,Object? watchHistory = null,Object? password = null,Object? accessToken = freezed,Object? refreshToken = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,coverImage: null == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String,watchHistory: null == watchHistory ? _self.watchHistory : watchHistory // ignore: cast_nullable_to_non_nullable
as List<dynamic>,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc

@JsonSerializable(explicitToJson: true)
class _User implements User {
   _User({@JsonKey(name: '_id', includeIfNull: false) this.id, @JsonKey(name: 'userName') this.userName = 'no-userName-provided', @JsonKey(name: 'email') this.email = 'no-email-provided', @JsonKey(name: 'fullName') this.fullName = 'no-fullName-provided', @JsonKey(name: 'avatar') this.avatar = 'no-avatar-provided', @JsonKey(name: 'coverImage') this.coverImage = 'no-coverImage-provided', @JsonKey(name: 'watchHistory') final  List<dynamic> watchHistory = const [], @JsonKey(name: 'password') this.password = 'no-password-provided', @JsonKey(name: 'accessToken', includeIfNull: false) this.accessToken = 'no-accessToken-provided', @JsonKey(name: 'refreshToken', includeIfNull: false) this.refreshToken = 'no-refreshToken-provided', @JsonKey(name: 'createdAt') this.createdAt = 'no-createdAt-provided', @JsonKey(name: 'updatedAt') this.updatedAt = 'no-updatedAt-provided'}): _watchHistory = watchHistory;
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey(name: '_id', includeIfNull: false) final  String? id;
@override@JsonKey(name: 'userName') final  String userName;
@override@JsonKey(name: 'email') final  String email;
@override@JsonKey(name: 'fullName') final  String fullName;
@override@JsonKey(name: 'avatar') final  String avatar;
@override@JsonKey(name: 'coverImage') final  String coverImage;
 final  List<dynamic> _watchHistory;
@override@JsonKey(name: 'watchHistory') List<dynamic> get watchHistory {
  if (_watchHistory is EqualUnmodifiableListView) return _watchHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_watchHistory);
}

@override@JsonKey(name: 'password') final  String password;
@override@JsonKey(name: 'accessToken', includeIfNull: false) final  String? accessToken;
@override@JsonKey(name: 'refreshToken', includeIfNull: false) final  String? refreshToken;
@override@JsonKey(name: 'createdAt') final  String createdAt;
@override@JsonKey(name: 'updatedAt') final  String updatedAt;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&const DeepCollectionEquality().equals(other._watchHistory, _watchHistory)&&(identical(other.password, password) || other.password == password)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userName,email,fullName,avatar,coverImage,const DeepCollectionEquality().hash(_watchHistory),password,accessToken,refreshToken,createdAt,updatedAt);

@override
String toString() {
  return 'User(id: $id, userName: $userName, email: $email, fullName: $fullName, avatar: $avatar, coverImage: $coverImage, watchHistory: $watchHistory, password: $password, accessToken: $accessToken, refreshToken: $refreshToken, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id', includeIfNull: false) String? id,@JsonKey(name: 'userName') String userName,@JsonKey(name: 'email') String email,@JsonKey(name: 'fullName') String fullName,@JsonKey(name: 'avatar') String avatar,@JsonKey(name: 'coverImage') String coverImage,@JsonKey(name: 'watchHistory') List<dynamic> watchHistory,@JsonKey(name: 'password') String password,@JsonKey(name: 'accessToken', includeIfNull: false) String? accessToken,@JsonKey(name: 'refreshToken', includeIfNull: false) String? refreshToken,@JsonKey(name: 'createdAt') String createdAt,@JsonKey(name: 'updatedAt') String updatedAt
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userName = null,Object? email = null,Object? fullName = null,Object? avatar = null,Object? coverImage = null,Object? watchHistory = null,Object? password = null,Object? accessToken = freezed,Object? refreshToken = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_User(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,coverImage: null == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String,watchHistory: null == watchHistory ? _self._watchHistory : watchHistory // ignore: cast_nullable_to_non_nullable
as List<dynamic>,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
