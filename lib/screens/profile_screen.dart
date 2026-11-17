import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

import 'package:focusbank/screens/welcome_screen.dart';
import 'package:focusbank/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final profile = state.profile;

        return Scaffold(
          backgroundColor: AppTheme.bgDark,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Title with Clock Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryGold.withValues(alpha: 0.15),
                        ),
                        child: const Icon(
                          Icons.schedule,
                          color: AppTheme.primaryGold,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: AppTheme.textWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Avatar & Name
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(
                              0xFF6B8CAE,
                            ), // Slate blue avatar from screenshot
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.name,
                          style: const TextStyle(
                            color: AppTheme.textWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.dreamCareer,
                          style: const TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3 Stat Boxes (Sessions, Focused, Earned)
                  Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          label: 'Sessions',
                          value: '${state.sessionCount}',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatBox(
                          label: 'Focused',
                          value: '${(state.totalMinutesFocused / 60).round()}h',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatBox(
                          label: 'Earned',
                          value:
                              '\$${state.balance.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          isEarned: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),

                  // ACCOUNT Group
                  _buildSectionHeader('ACCOUNT'),
                  _buildSettingsGroup([
                    _SettingsTile(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profile',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 18),

                  // FOCUS Group
                  _buildSectionHeader('FOCUS'),
                  _buildSettingsGroup([
                    _SettingsTile(
                      icon: Icons.timer_outlined,
                      title: 'Timer Duration',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.do_not_disturb_on_outlined,
                      title: 'Do Not Disturb',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 18),

                  // SUPPORT Group
                  _buildSectionHeader('SUPPORT'),
                  _buildSettingsGroup([
                    _SettingsTile(
                      icon: Icons.shield_outlined,
                      title: 'Privacy & Security',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & FAQ',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 26),

                  // Log Out Button
                  Center(
                    child: SizedBox(
                      width: 170,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // 1) End the real Firebase session.
                          await AuthService().logOut();

                          // 2) Reset the local fake data.
                          state.logout();

                          // 3) Go back to the Welcome screen and clear the navigation history,
                          //    so the Back button can't return to the app.
                          if (!context.mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        label: const Icon(
                          Icons.logout,
                          color: Colors.black,
                          size: 18,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGold,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textDim,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    // Material instead of Container: it can hold a color AND let the
    // ListTile's press effect show on top of it.
    return Material(
      color: AppTheme.surfaceCard,
      // Keeps the press effect inside the rounded corners.
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.surfaceBorder),
      ),
      child: Column(children: children),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isEarned;

  const _StatBox({
    required this.label,
    required this.value,
    this.isEarned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF192538), // Navy blue container from mockup
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2B3A54)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8E9EB5),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: isEarned ? AppTheme.primaryGold : Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      leading: Icon(icon, color: Colors.white, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textWhite,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.textDim,
        size: 18,
      ),
    );
  }
}
