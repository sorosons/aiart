import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex("#F5F5F5");
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color primaryOpacity70 = HexColor.fromHex("#B3ED9728");

  // new colors
  static Color darkPrimary = HexColor.fromHex("#d17d11");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color error = HexColor.fromHex("#e61f34");
  static Color black = HexColor.fromHex("#000000");
  static Color createBtnColor = HexColor.fromHex("#FA4248");
  static Color borderColor = HexColor.fromHex("#D8D8D8");
  //Greadient Colors
  static Color grad1 = HexColor.fromHex("#FC47D3");
  static Color grad2 = HexColor.fromHex("#BA40C4");
  static Color grad3 = HexColor.fromHex("#8C6CD5");
  static Color grad4 = HexColor.fromHex("#6D77E6");
  static Color grad5 = HexColor.fromHex("#3FC9B9");
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
