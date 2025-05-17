
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart'; // Ensure JSON serialization works
//flutter packages pub run build_runner build
@freezed
abstract class User  with _$User{
  @JsonSerializable(explicitToJson: true)
  factory User(
  {
    @JsonKey(name: '_id', includeIfNull: false) String? id,
    @Default('no-userName-provided')@JsonKey(name: 'userName') String userName,
    @Default('no-email-provided')@JsonKey(name: 'email') String email,
    @Default('no-fullName-provided')@JsonKey(name: 'fullName') String fullName,
    @Default('no-avatar-provided')@JsonKey(name: 'avatar') String avatar,
    @Default('no-coverImage-provided')@JsonKey(name: 'coverImage') String coverImage,
    @Default([])@JsonKey(name: 'watchHistory') List<dynamic> watchHistory,
    @Default('no-password-provided')@JsonKey(name:'password') String password,
    @Default('no-accessToken-provided')@JsonKey(name:'accessToken', includeIfNull: false) String? accessToken,
    @Default('no-refreshToken-provided')@JsonKey(name:'refreshToken', includeIfNull: false) String? refreshToken,
    @Default('no-createdAt-provided')@JsonKey(name: 'createdAt') String createdAt,
    @Default('no-updatedAt-provided')@JsonKey(name: 'updatedAt') String updatedAt,
  }
      )=_User;
    factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}