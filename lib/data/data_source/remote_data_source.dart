import 'dart:async';

import 'package:complete_advanced_flutter/app/logger_settings.dart';
import 'package:complete_advanced_flutter/data/network/app_api.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/data/responses/image_response.dart';
import 'package:complete_advanced_flutter/data/responses/init_response.dart';
import 'package:complete_advanced_flutter/data/responses/responses.dart';
import 'package:web_scraper/web_scraper.dart';

import '../../domain/model/image_model.dart';

abstract class RemoteDataSource {
  Future<InitResponse> initUser(InitUserRequest initUserRequest);
  Future<ImageResponse> getArts(String art);
  Future<ImageModel> getQualityArts(String art);
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

  @override
  Future<ImageModel> getQualityArts(String art) async {
    List<ImageItems> myList = [];

    logger.e("getQualityArts");
    final webScraper = WebScraper('https://lexica.art/');
    if (await webScraper.loadWebPage("?q=" + art)) {
      var elements = webScraper.getPageContent();

      var items = elements.split(
          "https://lexica-serve-encoded-images2.sharif.workers.dev/md2/");
      for (int index = 0; index <= items.length - 2; index++) {
        if (items[index].length < 100 && index < 7) {
          String imageSrc =
              "https://lexica-serve-encoded-images2.sharif.workers.dev/md2/${items[index].split("&")[0].split("\\")[0]}";
          logger.i(
              "https://lexica-serve-encoded-images2.sharif.workers.dev/md2/${items[index].split("&")[0].split("\\")[0]}");
          myList.add(ImageItems(imageSrc, imageSrc));
        }
      }
    }

    return ImageModel(myList);
  }
}
