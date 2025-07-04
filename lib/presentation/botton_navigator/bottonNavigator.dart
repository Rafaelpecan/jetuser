import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetrideruser/presentation/base_screen/bloc/base_screen_bloc.dart';

class CustomBottomNavigator extends StatelessWidget {
  const CustomBottomNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseScreenBloc, BaseScreenState>(
      builder: (context, state) {
        final int curPage = context.watch<BaseScreenBloc>().page;
        return BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', ),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Metodos de pagamento'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Rating'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
          unselectedItemColor: Colors.white54,
          selectedItemColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 0, 128, 192),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          currentIndex: curPage,
          onTap: (page) {
            context.read<BaseScreenBloc>().add(PageChange(page: page));
          },
        );
      },
    );
  }
}
