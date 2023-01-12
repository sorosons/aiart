import 'package:complete_advanced_flutter/domain/model/image_model.dart';

class SingletonImageList {
  late ImageModel imageItems;

  static final SingletonImageList _inst = SingletonImageList._internal();
  SingletonImageList._internal();

  factory SingletonImageList() {
    return _inst;
  }
}

class Peoples {
  late int id;
  late String name;

  static final Peoples _inst = Peoples._internal();

  Peoples._internal();

  factory Peoples() {
    return _inst;
  }
}
