// to convert the response into a non nullable object (model)

import 'package:complete_advanced_flutter/app/extensions.dart';
import 'package:complete_advanced_flutter/data/responses/image_response.dart';
import 'package:complete_advanced_flutter/data/responses/init_response.dart';
import 'package:complete_advanced_flutter/domain/model/image_model.dart';
import 'package:complete_advanced_flutter/domain/model/init_model.dart';

const EMPTY = "";
const ZERO = 0;

extension InitDataMapper on DataResponse {
  InitDataModel toDomain() {
    return InitDataModel(
      this.id?.orZero() ?? ZERO,
      this.subscribeStatus?.orEmpty() ?? EMPTY,
    );
  }
}

extension InitMapper on InitResponse {
  InitModel toDomain() {
    return InitModel(this.dataResponse!.toDomain());
  }
}

extension ImageItemMapper on ImageItemResponse {
  ImageItems toDomain() {
    return ImageItems(
        this.src?.orEmpty() ?? EMPTY, this.srcSmall?.orEmpty() ?? EMPTY);
  }
}

extension ImageMapper on ImageResponse {
  ImageModel toDomain() {
    List<ImageItems> imageData =
        (this.images?.map((e) => e.toDomain()) ?? Iterable.empty())
            .cast<ImageItems>()
            .toList();

    return ImageModel(imageData);
    ;
  }
}
