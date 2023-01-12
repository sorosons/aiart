// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageResponse _$ImageResponseFromJson(Map<String, dynamic> json) =>
    ImageResponse(
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ImageItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImageResponseToJson(ImageResponse instance) =>
    <String, dynamic>{
      'images': instance.images,
    };

ImageItemResponse _$ImageItemResponseFromJson(Map<String, dynamic> json) =>
    ImageItemResponse(
      src: json['src'] as String?,
      srcSmall: json['srcSmall'] as String?,
    );

Map<String, dynamic> _$ImageItemResponseToJson(ImageItemResponse instance) =>
    <String, dynamic>{
      'src': instance.src,
      'srcSmall': instance.srcSmall,
    };
