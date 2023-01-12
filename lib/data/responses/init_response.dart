import 'package:json_annotation/json_annotation.dart';
part 'init_response.g.dart';

@JsonSerializable()
class InitResponse {
  @JsonKey(name: "data")
  DataResponse? dataResponse;
  InitResponse(this.dataResponse);

  //to  Json
  Map<String, dynamic> toJson() => _$InitResponseToJson(this);

  //fromJson
  factory InitResponse.fromJson(Map<String, dynamic> json) =>
      _$InitResponseFromJson(json);
}

@JsonSerializable()
class DataResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "subscribeStatus")
  String? subscribeStatus;

  DataResponse(this.id, this.subscribeStatus);

  //to  Json
  Map<String, dynamic> toJson() => _$DataResponseToJson(this);

  //fromJson
  factory DataResponse.fromJson(Map<String, dynamic> json) =>
      _$DataResponseFromJson(json);
}
