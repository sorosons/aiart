import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

class ResultViewModel extends BaseViewModel
    with ResultViewModelInputs, ResultViewModelOutputs {
  @override
  void start() {}
  @override
  void dispose() {
    // super.dispose();
  }

  @override
  downloadImage(String url) async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(url);
      if (imageId == null) {
        return;
      }
    } on PlatformException catch (error) {
      print(error);
    }
  }

  @override
  shareImage(String url) {
    // TODO: implement shareImage
    throw UnimplementedError();
  }
}

abstract class ResultViewModelInputs {
  downloadImage(String url);
  shareImage(String url);
}

abstract class ResultViewModelOutputs {}
