import 'package:complete_advanced_flutter/app/constant.dart';
import 'package:complete_advanced_flutter/data/responses/image_response.dart';
import 'package:complete_advanced_flutter/data/responses/init_response.dart';
import 'package:complete_advanced_flutter/domain/model/image_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'app_api.g.dart';

class Apis {
  static const String initUser = "user/Init";
  static const String createArt = "";
}

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST(Apis.initUser)
  Future<InitResponse> initUser(
    @Field("mobileId") String mobileId,
  );

  @GET(Apis.createArt)
  Future<ImageResponse> getArts(
    @Query("q") String textToArt,
  );
}
