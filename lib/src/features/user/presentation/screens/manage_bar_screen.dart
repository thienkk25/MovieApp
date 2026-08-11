import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/global/settings_cubit.dart';
import '../../../../core/global/settings_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_movie_header.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import 'my_profile_screen.dart';

class ManageBarScreen extends StatefulWidget {
  const ManageBarScreen({super.key});

  @override
  State<ManageBarScreen> createState() => _ManageBarScreenState();
}

class _ManageBarScreenState extends State<ManageBarScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Tài khoản & Cài đặt',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: colors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // User Header Card
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final user = state.user;
                    return AnimatedMovieHeader(
                      profilePicture: user?.photoUrl ?? '',
                      userName: user?.displayName ?? 'Thành viên Cinema',
                      myselftEmail: user?.email ?? 'user@cinema.com',
                    );
                  },
                ).animate().fade(duration: 400.ms),

                const SizedBox(height: 20),

                // Settings Group Tile Card
                Container(
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    children: [
                      _buildTile(
                        icon: Icons.person_outline_rounded,
                        title: 'Thông tin cá nhân',
                        subtitle: 'Cập nhật ảnh đại diện & tên hiển thị',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MyProfileScreen()),
                          );
                        },
                      ),
                      Divider(height: 1, color: colors.divider),
                      BlocBuilder<SettingsCubit, SettingsState>(
                        builder: (context, settingsState) {
                          return _buildTile(
                            icon: Icons.palette_outlined,
                            title: 'Giao diện ứng dụng',
                            subtitle: _getThemeText(settingsState.themeMode),
                            onTap: () => _showThemeModal(context),
                          );
                        },
                      ),

                      Divider(height: 1, color: colors.divider),
                      BlocBuilder<SettingsCubit, SettingsState>(
                        builder: (context, settingsState) {
                          return _buildTile(
                            icon: Icons.notifications_none_rounded,
                            title: 'Thông báo',
                            subtitle: settingsState.isNotificationEnabled
                                ? 'Đã bật'
                                : 'Đã tắt',
                            onTap: () => _showNotificationModal(context),
                          );
                        },
                      ),
                    ],
                  ),
                ).animate().fade(duration: 500.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 16),

                // Logout Action Card
                Container(
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.border),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.logout_rounded,
                          color: Colors.redAccent, size: 20),
                    ),
                    title: const Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: Colors.redAccent),
                    onTap: () => _confirmLogout(context),
                  ),
                ),

                const SizedBox(height: 30),
                Text(
                  'Cinema App v1.4.0 • Clean Architecture',
                  style: TextStyle(color: colors.textTertiary, fontSize: 12),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.amber, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: colors.textTertiary, fontSize: 12),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: colors.iconInactive, size: 20),
      onTap: onTap,
    );
  }

  String _getThemeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Giao diện Sáng';
      case ThemeMode.dark:
        return 'Giao diện Tối';
      case ThemeMode.system:
        return 'Theo hệ thống';
    }
  }

  void _showThemeModal(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final colors = context.appColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              ListTile(
                leading:
                    const Icon(Icons.light_mode_outlined, color: Colors.amber),
                title:
                    Text('Sáng', style: TextStyle(color: colors.textPrimary)),
                onTap: () {
                  cubit.setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.dark_mode_outlined, color: Colors.amber),
                title: Text('Tối', style: TextStyle(color: colors.textPrimary)),
                onTap: () {
                  cubit.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_android_rounded,
                    color: Colors.amber),
                title: Text('Tự động theo hệ thống',
                    style: TextStyle(color: colors.textPrimary)),
                onTap: () {
                  cubit.setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }



  void _showNotificationModal(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final colors = context.appColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              ListTile(
                title: Text('Bật thông báo',
                    style: TextStyle(color: colors.textPrimary)),
                onTap: () {
                  cubit.setNotificationEnabled(true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Tắt thông báo',
                    style: TextStyle(color: colors.textPrimary)),
                onTap: () {
                  cubit.setNotificationEnabled(false);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    final colors = context.appColors;

    showDialog(
      context: context,
      builder: (contextDialog) => Dialog(
        backgroundColor: colors.dialogBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout_rounded,
                  color: Colors.redAccent, size: 40),
              const SizedBox(height: 16),
              Text(
                'Đăng xuất tài khoản?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không?',
                style: TextStyle(fontSize: 13, color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(contextDialog),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () {
                        Navigator.pop(contextDialog);
                        context
                            .read<AuthBloc>()
                            .add(const AuthEvent.logoutRequested());
                      },
                      child: const Text('Đăng xuất',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
