import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/global/settings_cubit.dart';
import '../../../../core/global/settings_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/animated_movie_header.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/screens/login_screen.dart';

import 'my_profile_screen.dart';
import 'watch_history_screen.dart';

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
            style:
                AppTextStyles.appBarTitle.copyWith(color: colors.textPrimary),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md, vertical: 12),
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

                // Account Settings Group
                Container(
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
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
                      _buildTile(
                        icon: Icons.history_rounded,
                        title: 'Lịch sử xem',
                        subtitle: 'Các phim bạn đã xem gần đây',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const WatchHistoryScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ).animate().fade(duration: 500.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 16),

                // App Settings Group
                Container(
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    children: [
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
                            icon: Icons.language_rounded,
                            title: 'Ngôn ngữ',
                            subtitle: _getLanguageText(settingsState.locale),
                            onTap: () => _showLanguageModal(context),
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
                      Divider(height: 1, color: colors.divider),
                      _buildTile(
                        icon: Icons.info_outline_rounded,
                        title: 'Về ứng dụng',
                        subtitle: 'Phiên bản, giấy phép, thông tin',
                        onTap: () => _showAboutDialog(context),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 600.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 16),

                // Logout Action Card
                Container(
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                    border: Border.all(color: colors.border),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.logout_rounded,
                          color: colors.error, size: 20),
                    ),
                    title: Text(
                      'Đăng xuất',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: colors.error),
                    ),
                    trailing:
                        Icon(Icons.chevron_right_rounded, color: colors.error),
                    onTap: () => _confirmLogout(context),
                  ),
                ),

                const SizedBox(height: 30),
                Text(
                  'Movie App v1.4.0 • by Thien Nguyen',
                  style: AppTextStyles.caption
                      .copyWith(color: colors.textTertiary),
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
          color: colors.accentGlow,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: colors.accentPrimary, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(color: colors.textPrimary),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(color: colors.textTertiary),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: colors.iconInactive, size: 20),
      onTap: onTap,
    );
  }

  String _getThemeText(ThemeMode mode) {
    return 'Giao diện Tối (Mặc định)';
  }

  String _getLanguageText(Locale locale) {
    return 'Tiếng Việt (Mặc định)';
  }

  // ─── Theme Modal ────────────────────────────────────────
  void _showThemeModal(BuildContext context) {
    final colors = context.appColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.sheetRadius)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              ListTile(
                leading:
                    Icon(Icons.dark_mode_outlined, color: colors.accentPrimary),
                title: Text('Giao diện Tối (Đã chọn)',
                    style: TextStyle(color: colors.textPrimary)),
                subtitle: Text('Ứng dụng hiện chỉ hỗ trợ Giao diện Tối',
                    style: TextStyle(color: colors.textTertiary)),
                onTap: () {
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

  // ─── Language Modal ─────────────────────────────────────
  void _showLanguageModal(BuildContext context) {
    final colors = context.appColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.sheetRadius)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              ListTile(
                leading: const Text('🇻🇳', style: TextStyle(fontSize: 24)),
                title: Text('Tiếng Việt (Đã chọn)',
                    style: TextStyle(color: colors.textPrimary)),
                subtitle: Text('Ứng dụng hiện chỉ hỗ trợ Tiếng Việt',
                    style: TextStyle(color: colors.textTertiary)),
                onTap: () {
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // ─── Notification Modal ─────────────────────────────────
  void _showNotificationModal(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final colors = context.appColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.sheetRadius)),
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

  // ─── About Dialog ───────────────────────────────────────
  void _showAboutDialog(BuildContext context) {
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: colors.dialogBg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colors.accentPrimary,
                      colors.accentSecondary,
                    ],
                  ),
                ),
                child: Icon(Icons.movie_creation_rounded,
                    color: colors.accentOnAccent, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                'Movie App',
                style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'Phiên bản 1.4.0',
                style: AppTextStyles.bodySmall
                    .copyWith(color: colors.textTertiary),
              ),
              const SizedBox(height: 16),
              Text(
                'Ứng dụng xem phim miễn phí. Tất cả dữ liệu phim được cung cấp bởi KKPhim.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall
                    .copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  showLicensePage(context: context);
                },
                child: Text(
                  'Xem giấy phép nguồn mở',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: colors.accentPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Confirm Logout ─────────────────────────────────────
  void _confirmLogout(BuildContext context) {
    final colors = context.appColors;

    showDialog(
      context: context,
      builder: (contextDialog) => Dialog(
        backgroundColor: colors.dialogBg,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout_rounded, color: colors.error, size: 40),
              const SizedBox(height: 16),
              Text(
                'Đăng xuất tài khoản?',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không?',
                style: AppTextStyles.bodySmall
                    .copyWith(color: colors.textSecondary),
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
                        backgroundColor: colors.error,
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
