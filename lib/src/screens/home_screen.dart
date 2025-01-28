import 'package:flutter/material.dart';
import 'package:movie_app/src/screens/bottomBar/favorite_bar_screen.dart';
import 'package:movie_app/src/screens/bottomBar/home_bar_screen.dart';
import 'package:movie_app/src/screens/bottomBar/manage_bar_screen.dart';
import 'package:movie_app/src/screens/bottomBar/search_bar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> pages = [
    const HomeBarScreen(),
    const FavoriteBarScreen(),
    const SearchBarScreen(),
    const ManageBarScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        animationDuration: const Duration(milliseconds: 300),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (value) => setState(() {
          selectedIndex = value;
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Trang chủ"),
          NavigationDestination(icon: Icon(Icons.favorite), label: "Yêu thích"),
          NavigationDestination(icon: Icon(Icons.search), label: "Tìm kiếm"),
          NavigationDestination(
              icon: Icon(Icons.manage_accounts), label: "Tài khoản"),
        ],
      ),
    );
  }
}
