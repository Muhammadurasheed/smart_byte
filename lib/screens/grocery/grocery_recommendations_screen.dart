import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_theme.dart';
import '../../widgets/navigation_wrapper.dart';

class GroceryRecommendationsScreen extends StatefulWidget {
  const GroceryRecommendationsScreen({super.key});

  @override
  State<GroceryRecommendationsScreen> createState() => _GroceryRecommendationsScreenState();
}

class _GroceryRecommendationsScreenState extends State<GroceryRecommendationsScreen> {
  final Set<String> _shoppingList = {};

  final List<Map<String, dynamic>> _recommendations = [
    {
      'name': 'Fresh Spinach',
      'reason': 'Add more iron and fiber to your diet',
      'category': 'Vegetables',
      'image': 'https://images.pexels.com/photos/2116094/pexels-photo-2116094.jpeg?auto=compress&cs=tinysrgb&w=800',
      'priority': 'high',
      'nutrition': 'High in Iron, Vitamin K, Folate',
    },
    {
      'name': 'Greek Yogurt',
      'reason': 'Boost your protein intake',
      'category': 'Dairy',
      'image': 'https://images.pexels.com/photos/1854652/pexels-photo-1854652.jpeg?auto=compress&cs=tinysrgb&w=800',
      'priority': 'medium',
      'nutrition': 'High in Protein, Probiotics',
    },
    {
      'name': 'Quinoa',
      'reason': 'Complete protein and complex carbs',
      'category': 'Grains',
      'image': 'https://images.pexels.com/photos/1187347/pexels-photo-1187347.jpeg?auto=compress&cs=tinysrgb&w=800',
      'priority': 'medium',
      'nutrition': 'Complete Protein, Fiber, Magnesium',
    },
    {
      'name': 'Blueberries',
      'reason': 'Antioxidants for brain health',
      'category': 'Fruits',
      'image': 'https://images.pexels.com/photos/461431/pexels-photo-461431.jpeg?auto=compress&cs=tinysrgb&w=800',
      'priority': 'high',
      'nutrition': 'Antioxidants, Vitamin C, Fiber',
    },
    {
      'name': 'Almonds',
      'reason': 'Healthy fats and portion control',
      'category': 'Nuts',
      'image': 'https://images.pexels.com/photos/1295572/pexels-photo-1295572.jpeg?auto=compress&cs=tinysrgb&w=800',
      'priority': 'low',
      'nutrition': 'Healthy Fats, Vitamin E, Protein',
    },
    {
      'name': 'Salmon',
      'reason': 'Omega-3 fatty acids missing from recent meals',
      'category': 'Protein',
      'image': 'https://images.pexels.com/photos/1516415/pexels-photo-1516415.jpeg?auto=compress&cs=tinysrgb&w=800',
      'priority': 'high',
      'nutrition': 'Omega-3, High Quality Protein',
    },
  ];

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'high':
        return 'High Priority';
      case 'medium':
        return 'Medium Priority';
      case 'low':
        return 'Nice to Have';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Smart Grocery List',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              color: AppColors.textPrimary,
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // Header with AI insights
            Container(
              margin: const EdgeInsets.all(AppSizes.paddingL),
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                gradient: AppColors.secondaryGradient,
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.3),
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
                          Icons.lightbulb,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingS),
                      Text(
                        'AI Recommendations',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Text(
                    'Based on your eating patterns and nutritional gaps, here are personalized grocery suggestions.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInsightCard('Missing Nutrients', 'Iron, Omega-3'),
                      ),
                      const SizedBox(width: AppSizes.paddingS),
                      Expanded(
                        child: _buildInsightCard('Shopping List', '${_shoppingList.length} items'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Recommendations list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
                itemCount: _recommendations.length,
                itemBuilder: (context, index) {
                  final item = _recommendations[index];
                  final isInList = _shoppingList.contains(item['name']);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
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
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      child: Row(
                        children: [
                          // Item image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.radiusM),
                            child: Image.network(
                              item['image'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: AppColors.divider,
                                  child: const Center(child: CircularProgressIndicator()),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingM),
                          
                          // Item details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['name'],
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSizes.paddingS,
                                        vertical: AppSizes.paddingXS,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getPriorityColor(item['priority']).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                                      ),
                                      child: Text(
                                        _getPriorityText(item['priority']),
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: _getPriorityColor(item['priority']),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSizes.paddingXS),
                                Text(
                                  item['reason'],
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.paddingXS),
                                Text(
                                  item['nutrition'],
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Add to list button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isInList) {
                                  _shoppingList.remove(item['name']);
                                } else {
                                  _shoppingList.add(item['name']);
                                }
                              });
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isInList 
                                        ? '${item['name']} removed from list'
                                        : '${item['name']} added to list',
                                  ),
                                  backgroundColor: isInList ? AppColors.warning : AppColors.success,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(AppSizes.paddingS),
                              decoration: BoxDecoration(
                                color: isInList 
                                    ? AppColors.success.withOpacity(0.1)
                                    : AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppSizes.radiusS),
                              ),
                              child: Icon(
                                isInList ? Icons.check : Icons.add,
                                color: isInList ? AppColors.success : AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: _shoppingList.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  _showShoppingList();
                },
                backgroundColor: AppColors.primary,
                label: Text(
                  'View List (${_shoppingList.length})',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              )
            : null,
      ),
    );
  }

  Widget _buildInsightCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingS),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showShoppingList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusL)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shopping List',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  ..._shoppingList.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.paddingS),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.success, size: 20),
                        const SizedBox(width: AppSizes.paddingS),
                        Text(
                          item,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                  const SizedBox(height: AppSizes.paddingL),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Here you could integrate with grocery delivery apps
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Feature coming soon: Export to grocery apps!'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        ),
                      ),
                      child: Text(
                        'Export to Grocery App',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}