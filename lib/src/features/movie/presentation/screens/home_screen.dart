import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/core/theme/app_colors.dart';
import 'package:movie_app/src/features/movie/presentation/screens/bottomBar/favorite_bar_screen.dart';
import 'package:movie_app/src/features/movie/presentation/screens/bottomBar/home_bar_screen.dart';
import 'package:movie_app/src/features/user/presentation/screens/manage_bar_screen.dart';
import 'package:movie_app/src/features/movie/presentation/screens/bottomBar/search_bar_screen.dart';

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
    final colors = context.appColors;
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 72,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
            color: colors.navBarBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.navBarBorder,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.navBarShadow,
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      label: 'app.home'.tr(),
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: Icons.favorite_outline,
                      selectedIcon: Icons.favorite_rounded,
                      label: 'app.favorites'.tr(),
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: Icons.search,
                      selectedIcon: Icons.search_rounded,
                      label: 'app.search'.tr(),
                    ),
                    _buildNavItem(
                      index: 3,
                      icon: Icons.manage_accounts_outlined,
                      selectedIcon: Icons.manage_accounts_rounded,
                      label: 'app.account'.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    final colors = context.appColors;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isSelected
                    ? Colors.orangeAccent.withValues(alpha: 0.12)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? Colors.orangeAccent.withValues(alpha: 0.2)
                      : Colors.transparent,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.orangeAccent.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? Colors.orangeAccent : colors.iconInactive,
                size: 24,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? colors.textPrimary : colors.iconInactive,
                letterSpacing: isSelected ? 0.3 : 0.1,
                shadows: isSelected
                    ? [
                        Shadow(
                          color: Colors.orangeAccent.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
