import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/meal_provider.dart';
import '../../providers/hardware_provider.dart';
import '../../widgets/navigation_wrapper.dart';
import '../meal/meal_logging_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  @override
  void initState() {
    super.initState();
    // Initialize hardware connection when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HardwareProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: RefreshIndicator(
          onRefresh: () async {
            // Add refresh logic here
            await Future.delayed(const Duration(seconds: 1));
          },
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverPadding(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSmartSpoonSummary(context),
                    const SizedBox(height: AppSizes.paddingL),
                    _buildTodayOverview(context),
                    const SizedBox(height: AppSizes.paddingL),
                    _buildRecentMeals(context),
                    const SizedBox(height: AppSizes.paddingL),
                    _buildAISuggestions(context),
                    const SizedBox(height: AppSizes.paddingXL),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.background, Color(0xFFF8F9FA)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              userProvider.name.isNotEmpty 
                                  ? userProvider.name[0].toUpperCase()
                                  : 'U',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  userProvider.name.isNotEmpty 
                                      ? userProvider.name 
                                      : 'User',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            color: AppColors.textPrimary,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmartSpoonSummary(BuildContext context) {
    return Consumer2<HardwareProvider, UserProvider>(
      builder: (context, hardwareProvider, userProvider, child) {
        final hardwareData = hardwareProvider.hardwareData;
        final isConnected = hardwareProvider.isConnected;
        final isLoading = hardwareProvider.isLoading;
        
        // Send calorie comparison when data updates
        if (isConnected && hardwareData.calorie > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            hardwareProvider.sendCalorieComparison(
              hardwareData.calorie, 
              userProvider.maxCalorie
            );
          });
        }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingS),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Expanded(
                    child: Text(
                      'Smart Spoon Summary',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Connection status indicator
                  if (!isConnected && !isLoading)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingS,
                        vertical: AppSizes.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.wifi_off,
                            color: Colors.orange.shade100,
                            size: 14,
                          ),
                          const SizedBox(width: AppSizes.paddingXS),
                          Text(
                            'Offline',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.orange.shade100,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Refresh button
                  const SizedBox(width: AppSizes.paddingS),
                  GestureDetector(
                    onTap: isLoading ? null : () => hardwareProvider.refresh(),
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.paddingS),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.8),
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              Icons.refresh,
                              color: Colors.white.withOpacity(0.8),
                              size: 16,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingL),
              Row(
                children: [
                  Expanded(
                    child: _buildSpoonMetric(
                      'Unit', 
                      '${hardwareData.calorie.toInt()}',
                      'g',
                      Icons.local_fire_department,
                      isConnected,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: _buildSpoonMetric(
                      'Bite/min', 
                      hardwareData.eatingSpeed.toStringAsFixed(1),
                      'bite/min',
                      Icons.speed,
                      isConnected,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
              Row(
                children: [
                  Expanded(
                    child: _buildSpoonMetric(
                      'Run time', 
                      '${hardwareData.mealDuration.toInt()}',
                      'min',
                      Icons.timer,
                      isConnected,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: _buildSpoonMetric(
                      'Max Unit', 
                      userProvider.maxCalorie > 0 
                          ? '${userProvider.maxCalorie.toInt()}'
                          : '0',
                      'g',
                      Icons.flag,
                      true, // Always show this as it's user data
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpoonMetric(String label, String value, String unit, IconData icon, bool isConnected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon, 
              color: isConnected 
                  ? Colors.white.withOpacity(0.8) 
                  : Colors.white.withOpacity(0.5), 
              size: 16
            ),
            const SizedBox(width: AppSizes.paddingXS),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isConnected 
                      ? Colors.white.withOpacity(0.8)
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingXS),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: isConnected ? value : '0',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isConnected ? Colors.white : Colors.white.withOpacity(0.6),
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isConnected 
                      ? Colors.white.withOpacity(0.7)
                      : Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodayOverview(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                    "Today's Overview",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MealLoggingScreen(),
                        ),
                      );
                    },
                    child: Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingS,
                          vertical: AppSizes.paddingXS,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.secondaryGradient,
                          borderRadius: BorderRadius.circular(AppSizes.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, color: Colors.white, size: 14),
                            const SizedBox(width: AppSizes.paddingXS),
                            Text(
                              'Log Meal',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingL),
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewMetric(
                      'Calories',
                      '${mealProvider.todayCalories.round()}',
                      '/ 2000',
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: _buildOverviewMetric(
                      'Meals',
                      '${mealProvider.meals.length}',
                      '/ 4',
                      AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewMetric(String label, String value, String target, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSizes.paddingXS),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              TextSpan(
                text: target,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentMeals(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        final recentMeals = mealProvider.meals.take(3).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Meals',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingM),
            ...recentMeals.map((meal) => _buildMealCard(meal)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildMealCard(Meal meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: Image.network(
                meal.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 60,
                    height: 60,
                    color: AppColors.divider,
                    child: Icon(
                      Icons.restaurant_menu,
                      color: AppColors.textLight,
                      size: 24,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: AppColors.divider,
                    child: Icon(
                      Icons.restaurant_menu,
                      color: AppColors.textLight,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXS),
                Text(
                  '${meal.calories.toInt()} cal • ${meal.portionSize.toInt()}g',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingS,
              vertical: AppSizes.paddingXS,
            ),
            decoration: BoxDecoration(
              color: meal.eatingSpeed > 25 
                  ? AppColors.warning.withOpacity(0.1)
                  : AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: Text(
              '${meal.eatingSpeed.round()} g/min',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: meal.eatingSpeed > 25 ? AppColors.warning : AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAISuggestions(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        final suggestions = mealProvider.aiSuggestions;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Insights',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            ...suggestions.map((suggestion) => _buildSuggestionCard(suggestion)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildSuggestionCard(String suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.divider.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingS),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Text(
              suggestion,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}