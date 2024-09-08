// ignore: constant_identifier_names
import 'package:flutter/widgets.dart';

enum ScreenType { Handset, Tablet, Desktop, Watch }
// ignore: constant_identifier_names
enum ScreenSize { Small, Normal, Large, ExtraLarge }

class FormFactor {
  static double desktop = 900;
  static double tablet = 600;
  static double handset = 300;
}

class DeviceSize {
  static ScreenType getFormFactor(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.shortestSide;
    if (deviceWidth > FormFactor.desktop) return ScreenType.Desktop;
    if (deviceWidth > FormFactor.tablet) return ScreenType.Tablet;
    if (deviceWidth > FormFactor.handset) return ScreenType.Handset;
    return ScreenType.Watch;
  }
  static ScreenSize getSize(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.shortestSide;
    if (deviceWidth > 900) return ScreenSize.ExtraLarge;
    if (deviceWidth > 600) return ScreenSize.Large;
    if (deviceWidth > 300) return ScreenSize.Normal;
    return ScreenSize.Small;
  }
  static bool isMobileLayout(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 600;
  }
}