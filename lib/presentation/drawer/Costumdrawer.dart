import 'package:flutter/material.dart';
import 'package:jetrideruser/presentation/drawer/costumdrawerHeader.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.white,
      child: Stack(children: <Widget>[
        _drawerBackground(),
        ListView(
          children: <Widget>[
            const CustomDrawerHeader(),
            _drawerTile(Icons.home, "Inicio", 0),
            _drawerTile(Icons.list, "Dados do usuario", 1),
            _drawerTile(Icons.playlist_add, "Dados do Jet", 2),
            _drawerTile(Icons.location_on, "Corridas", 3),
          ],
        ),
      ]),
    );
  }

  Widget _drawerTile(IconData iconData, String title, int page) {
     // final int curPage = context.watch<BaseScreenBloc>().page;
     // final Color primaryColor = Theme.of(context).primaryColor;
      return InkWell(
        onTap: () {
         // context.read<BaseScreenBloc>().add(PageChange(page: page));
        },
        child: SizedBox(
          height: 60,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Icon(iconData,
                    size: 32,
                   // color: (curPage == page) ? primaryColor : Colors.grey[700]
                   color: Colors.blue,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }
}

  Widget _drawerBackground() {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 203, 236, 241),
        Colors.white,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      )
    )
  );
}