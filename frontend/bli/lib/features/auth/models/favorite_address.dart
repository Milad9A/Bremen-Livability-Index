import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_address.freezed.dart';
part 'favorite_address.g.dart';

@freezed
class FavoriteAddress with _$FavoriteAddress {
  const factory FavoriteAddress({
    required String id,
    required String label,
    required double latitude,
    required double longitude,
    String? address,
    required DateTime createdAt,
  }) = _FavoriteAddress;

  factory FavoriteAddress.fromJson(Map<String, dynamic> json) =>
      _$FavoriteAddressFromJson(json);
}
