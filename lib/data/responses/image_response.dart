import 'package:json_annotation/json_annotation.dart';
part 'image_response.g.dart';

@JsonSerializable()
class ImageResponse {
  @JsonKey(name: "images")
  List<ImageItemResponse>? images;

  ImageResponse({
    this.images,
  });

  //to  Json
  Map<String, dynamic> toJson() => _$ImageResponseToJson(this);

  //fromJson
  factory ImageResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageResponseFromJson(json);
}

@JsonSerializable()
class ImageItemResponse {
  ImageItemResponse({
    this.src,
    this.srcSmall,
  });

  @JsonKey(name: "src")
  String? src;
  @JsonKey(name: "srcSmall")
  String? srcSmall;

  //to  Json
  Map<String, dynamic> toJson() => _$ImageItemResponseToJson(this);

  //fromJson
  factory ImageItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageItemResponseFromJson(json);
}
