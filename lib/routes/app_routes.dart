import 'package:flutter/material.dart';
import 'package:jetrideruser/presentation/base_screen/baseScreen.dart';
import 'package:jetrideruser/presentation/carInfo_screen/carInfoScreen.dart';
import 'package:jetrideruser/presentation/home_screen/searchplace.dart';
import 'package:jetrideruser/presentation/login_screen/loginScreen.dart';
import 'package:jetrideruser/presentation/register_screen/registerScreen.dart';
import 'package:jetrideruser/presentation/splashScreen/splash_screen.dart';

class AppRoutes{

  static const String baseScreen = '/baseScreen';
  static const String splash_screen = "/splash_screen";
  static const String registerScreen = '/register_screen';
  static const String carInfoScreen = 'carInfo_Screen';
  static const String loginScreen = '/login_screen';
  static const String searchplace = "searchplace";
  static const String initialRoute = '/initialRoute';

  
  static Map<String, WidgetBuilder> get routes => {
    baseScreen: BaseScreen.builder,
    splash_screen: SplashScreen.builder,
    registerScreen: RegisterScreen.builder,
    carInfoScreen: CarInfoScreen.builder,
    loginScreen: LoginScreen.builder,
    searchplace: Searchplace.builder,
    initialRoute: SplashScreen.builder,
  };
}