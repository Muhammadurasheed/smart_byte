import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/gradient_button.dart';
import '../../providers/user_provider.dart';
import '../home/home_dashboard.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String _selectedGoal = '';

  final List<Map<String, dynamic>> goals = [
    {
      'title': 'Weight Management',
      'description': 'Lose, gain, or maintain weight with smart portion control',
      'icon': Icons.fitness_center,
      'color': AppColors.primary,
      'image': 'https://images.pexels.com/photos/416778/pexels-photo-416778.jpeg?auto=compress&cs=tinysrgb&w=800',
    },
    {
      'title': 'Health Support',
      'description': 'Manage diabetes, heart health, or other conditions',
      'icon': Icons.favorite,
      'color': AppColors.secondary,
      'image': 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800',
    },
    {
      'title': 'Lifestyle & Wellness',
      'description': 'Build balanced eating habits and mindful nutrition',
      'icon': Icons.self_improvement,
      'color': AppColors.accent,
      'image': 'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg?auto=compress&cs=tinysrgb&w=800',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Choose Your Goal',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What brings you to SmartByte?',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              'Select your primary wellness goal to get personalized recommendations.',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),
            
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  final isSelected = _selectedGoal == goal['title'];
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSizes.paddingL),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGoal = goal['title'];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                          border: Border.all(
                            color: isSelected ? goal['color'] : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: goal['color'].withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                          child: Container(
                            height: 200,
                            child: Stack(
                              children: [
                                // Background image
                                Positioned.fill(
                                  child: Image.network(
                                    goal['image'],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: AppColors.divider,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                
                                // Overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.2),
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // Content
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.paddingL),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(AppSizes.paddingS),
                                              decoration: BoxDecoration(
                                                color: goal['color'],
                                                borderRadius: BorderRadius.circular(AppSizes.radiusS),
                                              ),
                                              child: Icon(
                                                goal['icon'],
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                            const Spacer(),
                                            if (isSelected)
                                              Container(
                                                padding: const EdgeInsets.all(AppSizes.paddingXS),
                                                decoration: BoxDecoration(
                                                  color: goal['color'],
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          goal['title'],
                                          style: GoogleFonts.inter(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: AppSizes.paddingS),
                                        Text(
                                          goal['description'],
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: AppSizes.paddingL),
            
            GradientButton(
              text: 'Start My Journey',
              onPressed: _selectedGoal.isNotEmpty ? () {
                context.read<UserProvider>().updateUserInfo(goal: _selectedGoal);
                context.read<UserProvider>().completeSetup();
                
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const HomeDashboard(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                  (route) => false,
                );
              } : null,
            ),
          ],
        ),
      ),
    );
  }
}