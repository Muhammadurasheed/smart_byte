import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/navigation_wrapper.dart';
import '../../providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Settings',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile section
              _buildProfileSection(context),
              const SizedBox(height: AppSizes.paddingL),
              
              // Personal Details
              _buildSettingsSection(
                'Personal Details',
                [
                  _buildSettingsItem(
                    Icons.person_outline,
                    'Edit Profile',
                    'Update your personal information',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.fitness_center,
                    'Health Goals',
                    'Modify your wellness objectives',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.timeline,
                    'Progress Tracking',
                    'View your journey analytics',
                    () {},
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.paddingL),
              
              // Device Setup
              _buildSettingsSection(
                'Smart Spoon',
                [
                  _buildSettingsItem(
                    Icons.bluetooth,
                    'Device Pairing',
                    'Connect your Smart Spoon',
                    () {},
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingS,
                        vertical: AppSizes.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                      ),
                      child: Text(
                        'Connected',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ),
                  _buildSettingsItem(
                    Icons.tune,
                    'Sensitivity Settings',
                    'Adjust bite detection accuracy',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.battery_charging_full,
                    'Battery Status',
                    '89% - Good condition',
                    () {},
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.paddingL),
              
              // Notifications
              _buildSettingsSection(
                'Notifications',
                [
                  _buildSettingsItem(
                    Icons.notifications_outlined,
                    'Meal Reminders',
                    'Get notified about meal times',
                    () {},
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: AppColors.primary,
                    ),
                  ),
                  _buildSettingsItem(
                    Icons.speed,
                    'Eating Speed Alerts',
                    'Warnings when eating too fast',
                    () {},
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: AppColors.primary,
                    ),
                  ),
                  _buildSettingsItem(
                    Icons.shopping_cart_outlined,
                    'Grocery Suggestions',
                    'Weekly shopping recommendations',
                    () {},
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.paddingL),
              
              // Help & Support
              _buildSettingsSection(
                'Help & Support',
                [
                  _buildSettingsItem(
                    Icons.help_outline,
                    'FAQ',
                    'Frequently asked questions',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.chat_bubble_outline,
                    'Contact Support',
                    'Get help from our team',
                    () {},
                  ),
                  _buildSettingsItem(
                    Icons.info_outline,
                    'About SmartByte',
                    'App version and information',
                    () {},
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.paddingXL),
              
              // Sign Out
              Container(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    _showSignOutDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                  ),
                  child: Text(
                    'Sign Out',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSizes.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  userProvider.name.isNotEmpty 
                      ? userProvider.name[0].toUpperCase()
                      : 'U',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProvider.name.isNotEmpty ? userProvider.name : 'User',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingXS),
                    Text(
                      userProvider.goal.isNotEmpty ? userProvider.goal : 'Wellness Journey',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    if (userProvider.bmi > 0) ...[
                      const SizedBox(height: AppSizes.paddingXS),
                      Text(
                        'BMI: ${userProvider.bmi.toStringAsFixed(1)} (${userProvider.bmiCategory})',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSizes.paddingS),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusS),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textLight),
      onTap: onTap,
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
          ),
          title: Text(
            'Sign Out',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out? Your data will be saved.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Here you would typically handle sign out logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sign out functionality coming soon!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: Text(
                'Sign Out',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}