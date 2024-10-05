import 'package:flutter/material.dart';

const Color linkColor = Color(0xff0893DF);
const Color actionColor = Color(0xffEAD428);

const int OTP_CODE_LENGTH = 4;

const double defaultLat = 31.5359232;
const double defaultLon = 34.48832;

const Color appGreenColor = Color(0xff0CAF60);
const Color appRedColor = Color(0xffF1416C);

const Color successColor = Color(0xff0CAF60);
const Color failColor = Color(0xffE04E4E);

extension HexColor on Colors {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}