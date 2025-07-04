import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthManager.dart';
import 'package:jetrideruser/routes/app_routes.dart';

class CustomDrawerHeader extends StatefulWidget {
  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  State<CustomDrawerHeader> createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  @override
  Widget build(BuildContext context) {
    String? name = context.read<EmailAndPassAuth>().user?.username;
    return Container(
        padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
        height: 180,
        child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'jetRider',
                      style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    "Ola, ${name ?? ""}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                      style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.loginScreen),
                    child: Text('Sair',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    )  ,
                  ),
                )
              ]
            )
          ); 
        }
      }
