import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
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
  final List<Widget> pages = const [
    HomeBarScreen(),
    FavoriteBarScreen(),
    SearchBarScreen(),
    ManageBarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: isDark
                    ? Colors.black.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.85),
                indicatorColor:
                    theme.colorScheme.primary.withValues(alpha: 0.2),
                labelTextStyle: WidgetStateProperty.all(
                  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              child: NavigationBar(
                selectedIndex: selectedIndex,
                elevation: 0,
                height: 70,
                animationDuration: const Duration(milliseconds: 400),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                destinations: [
                  _buildDestination(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    label: 'app.home'.tr(),
                    isSelected: selectedIndex == 0,
                  ),
                  _buildDestination(
                    icon: Icons.favorite_outline,
                    selectedIcon: Icons.favorite_rounded,
                    label: 'app.favorites'.tr(),
                    isSelected: selectedIndex == 1,
                  ),
                  _buildDestination(
                    icon: Icons.search,
                    selectedIcon: Icons.search_rounded,
                    label: 'app.search'.tr(),
                    isSelected: selectedIndex == 2,
                  ),
                  _buildDestination(
                    icon: Icons.manage_accounts_outlined,
                    selectedIcon: Icons.manage_accounts_rounded,
                    label: 'app.account'.tr(),
                    isSelected: selectedIndex == 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  NavigationDestination _buildDestination({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
  }) {
    return NavigationDestination(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        ),
        child: Icon(
          isSelected ? selectedIcon : icon,
          key: ValueKey(isSelected),
          size: isSelected ? 28 : 24,
          color: isSelected ? Colors.blueAccent : Colors.grey,
        ),
      ),
      label: label,
    );
  }
}
