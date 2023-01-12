import 'dart:ui';

import 'package:flutter/cupertino.dart';

class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(this.title, this.subTitle, this.image);
}

class DeviceInfo {
  String name;
  String identifier;
  String version;

  DeviceInfo(this.name, this.identifier, this.version);

  @override
  String toString() {
    // TODO: implement toString
    return "Device Name:" +
        name +
        " Device identifier:" +
        identifier +
        " Version:" +
        version;
  }
}

class GridListItems {
  String title;
  String image;
  GridListItems(this.title, this.image);
}

class MyPrompts {
  String prompts;
  String logo;
  MyPrompts(this.prompts, this.logo);
}

class SettingsListTile {
  String imageAssets;
  Color color;
  String tittle;
  final IconData? iconData;
  SettingsListTile(this.imageAssets, this.color, this.tittle, this.iconData);
}
