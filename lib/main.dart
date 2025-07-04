import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthManager.dart';
import 'package:jetrideruser/presentation/home_screen/bloc/geo_bloc.dart';
import 'package:jetrideruser/presentation/home_screen/bloc/map_bloc.dart';
import 'package:jetrideruser/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          lazy: false,
          create: (context) => EmailAndPassAuth(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GeoBloc()..add(LoadUserLocation()),
          ),
          BlocProvider(
            create: (context) => MapBloc(authRepo: context.read<EmailAndPassAuth>())..add(InitialMapEvent()),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          title: 'JetRider',
          theme: ThemeData(
              primaryColor: const Color.fromARGB(255, 3, 69, 122),
              scaffoldBackgroundColor: const Color.fromARGB(255, 3, 69, 122),
              appBarTheme: const AppBarTheme(
                  elevation: 0, foregroundColor: Colors.white)),
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.routes,
        ),
      ),
    );
  }
}
