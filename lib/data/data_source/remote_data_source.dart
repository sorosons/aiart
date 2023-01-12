import 'package:complete_advanced_flutter/data/network/app_api.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/data/responses/image_response.dart';
import 'package:complete_advanced_flutter/data/responses/init_response.dart';
import 'package:complete_advanced_flutter/data/responses/responses.dart';

abstract class RemoteDataSource {
  Future<InitResponse> initUser(InitUserRequest initUserRequest);
  Future<ImageResponse> getArts(String art);
}

class RemoteDataSourceImplementer implements RemoteDataSource {
  AppServiceClient _appServiceClient;

  RemoteDataSourceImplementer(this._appServiceClient);

  @override
  Future<InitResponse> initUser(InitUserRequest initUserRequest) {
    return _appServiceClient.initUser(initUserRequest.mobileId);
  }

  @override
  Future<ImageResponse> getArts(String art) {
    return _appServiceClient.getArts(art);
  }
}
