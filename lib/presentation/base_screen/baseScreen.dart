import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetrideruser/presentation/Earning_screen/EarningScreen.dart';
import 'package:jetrideruser/presentation/base_screen/bloc/base_screen_bloc.dart';
import 'package:jetrideruser/presentation/home_screen/homeScreen.dart';
import 'package:jetrideruser/presentation/profile_screen/profileScreen.dart';
import 'package:jetrideruser/presentation/rating_screen/ratingScreen.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key});

  final PageController pageController = PageController();

  static Widget builder(BuildContext context) {
    return BaseScreen();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BaseScreenBloc(pageController: pageController),
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          const HomeScreen(),
          EarningScreen(),
          const Profilescreen(),
          const Ratingscreen(),
        ],
      ),
    );
  }
}
