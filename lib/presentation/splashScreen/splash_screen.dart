import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthManager.dart';
import 'package:jetrideruser/presentation/base_screen/baseScreen.dart';
import 'package:jetrideruser/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});


  static Widget builder(BuildContext context) {
    return const SplashScreen();
  }


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 4)).then((_) async {
      if(await context.read<EmailAndPassAuth>().user?.username == null){
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginScreen, (route)=> false);
      }else{
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.baseScreen, (route) => false);
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                    Image.asset("images/logouser.png"),
                    const Text(
                      'JETRDER User App',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontFamily: 'Montserrat',
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2), 
                            blurRadius: 4.0,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                ]
            ),
        )
    );
  }
}