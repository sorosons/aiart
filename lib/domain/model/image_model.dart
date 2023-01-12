class ImageModel {
  List<ImageItems> images;

  ImageModel(this.images);
}

class ImageItems {
  String src;
  String srcSmall;
  ImageItems(
    this.src,
    this.srcSmall,
  );
}
