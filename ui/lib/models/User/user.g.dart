// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['_id'] as String?,
  userName: json['userName'] as String? ?? 'no-userName-provided',
  email: json['email'] as String? ?? 'no-email-provided',
  fullName: json['fullName'] as String? ?? 'no-fullName-provided',
  avatar: json['avatar'] as String? ?? 'no-avatar-provided',
  coverImage: json['coverImage'] as String? ?? 'no-coverImage-provided',
  watchHistory: json['watchHistory'] as List<dynamic>? ?? const [],
  password: json['password'] as String? ?? 'no-password-provided',
  accessToken: json['accessToken'] as String? ?? 'no-accessToken-provided',
  refreshToken: json['refreshToken'] as String? ?? 'no-refreshToken-provided',
  createdAt: json['createdAt'] as String? ?? 'no-createdAt-provided',
  updatedAt: json['updatedAt'] as String? ?? 'no-updatedAt-provided',
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  if (instance.id case final value?) '_id': value,
  'userName': instance.userName,
  'email': instance.email,
  'fullName': instance.fullName,
  'avatar': instance.avatar,
  'coverImage': instance.coverImage,
  'watchHistory': instance.watchHistory,
  'password': instance.password,
  if (instance.accessToken case final value?) 'accessToken': value,
  if (instance.refreshToken case final value?) 'refreshToken': value,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
