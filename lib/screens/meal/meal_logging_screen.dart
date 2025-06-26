import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/navigation_wrapper.dart';
import '../../widgets/gradient_button.dart';
import '../../providers/meal_provider.dart';
import '../home/home_dashboard.dart';

class MealLoggingScreen extends StatefulWidget {
  const MealLoggingScreen({super.key});

  @override
  State<MealLoggingScreen> createState() => _MealLoggingScreenState();
}

class _MealLoggingScreenState extends State<MealLoggingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedImagePath;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
        _isAnalyzing = true;
      });
      
      // Simulate AI analysis
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isAnalyzing = false;
        _analysisResult = {
          'name': 'Grilled Chicken Bowl',
          'calories': 385.0,
          'carbs': 22.0,
          'protein': 32.0,
          'fat': 16.0,
          'fiber': 8.0,
          'portionSize': 290.0,
          'confidence': 0.89,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationWrapper(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Log Your Meal',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            if (_analysisResult != null)
              TextButton(
                onPressed: _saveMeal,
                child: Text(
                  'Save',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedImagePath == null) ...[
                _buildImageCapture(),
              ] else ...[
                _buildImagePreview(),
                const SizedBox(height: AppSizes.paddingL),
                if (_isAnalyzing) _buildAnalyzing(),
                if (_analysisResult != null) _buildAnalysisResults(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCapture() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                border: Border.all(
                  color: AppColors.divider,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  Text(
                    'Capture your meal',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    'Our AI will analyze your food and estimate\nnutrition information automatically',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: GradientButton(
                      width: double.infinity,
                      text: 'Take Photo',
                      icon: Icons.camera_alt,
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.photo_library, color: AppColors.primary, size: 18),
                              const SizedBox(width: AppSizes.paddingS),
                              Flexible(
                                child: Text(
                                  'Gallery',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Stack(
          children: [
            // Display actual selected image or placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.divider,
              ),
              child: _selectedImagePath != null
                  ? Image.network(
                      // In a real app, you'd use File(_selectedImagePath!), but for demo we'll use a placeholder
                      'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppColors.divider,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image,
                                color: AppColors.textLight,
                                size: 48,
                              ),
                              const SizedBox(height: AppSizes.paddingS),
                              Text(
                                'Selected Image',
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppColors.divider,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                                const SizedBox(height: AppSizes.paddingS),
                                Text(
                                  'Loading image...',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: AppColors.divider,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_not_supported,
                            color: AppColors.textLight,
                            size: 48,
                          ),
                          const SizedBox(height: AppSizes.paddingS),
                          Text(
                            'No image selected',
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            // Selected image indicator overlay
            if (_selectedImagePath != null)
              Positioned(
                bottom: AppSizes.paddingM,
                left: AppSizes.paddingM,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingS,
                    vertical: AppSizes.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 16,
                      ),
                      const SizedBox(width: AppSizes.paddingXS),
                      Text(
                        'Image Selected',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Close button
            Positioned(
              top: AppSizes.paddingM,
              right: AppSizes.paddingM,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImagePath = null;
                    _analysisResult = null;
                    _isAnalyzing = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.paddingS),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzing() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
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
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: AppSizes.paddingL),
          Text(
            'Analyzing your meal...',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            'Our AI is identifying ingredients and calculating nutrition',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    final result = _analysisResult!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                      result['name'],
                      style: GoogleFonts.inter(
                        fontSize: 20,
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
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                    child: Text(
                      '${(result['confidence'] * 100).toInt()}% confident',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingL),
              
              // Nutrition info
              Row(
                children: [
                  Expanded(
                    child: _buildNutritionCard(
                      'Calories',
                      '${result['calories'].round()}',
                      'kcal',
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: _buildNutritionCard(
                      'Portion',
                      '${result['portionSize'].round()}',
                      'g',
                      AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
              
              // Macros
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Macronutrients',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    Row(
                      children: [
                        Expanded(child: _buildMacroBar('Carbs', result['carbs'], 60, AppColors.warning)),
                        const SizedBox(width: AppSizes.paddingS),
                        Expanded(child: _buildMacroBar('Protein', result['protein'], 50, AppColors.primary)),
                        const SizedBox(width: AppSizes.paddingS),
                        Expanded(child: _buildMacroBar('Fat', result['fat'], 30, AppColors.secondary)),
                        const SizedBox(width: AppSizes.paddingS),
                        Expanded(child: _buildMacroBar('Fiber', result['fiber'], 15, AppColors.success)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.paddingL),
        
        // Serving size adjustment
        Container(
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
              Text(
                'Adjust Serving Size',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                  ),
                  Expanded(
                    child: Text(
                      '1.0 serving',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionCard(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXS),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: color.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBar(String label, dynamic value, double max, Color color) {
    // Convert value to double safely
    final double doubleValue = (value is int) ? value.toDouble() : value as double;
    final percentage = (doubleValue / max).clamp(0.0, 1.0);
    
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.paddingXS),
        Text(
          '${doubleValue.round()}g',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

   void _saveMeal() {
    if (_analysisResult == null) return;
    
    final result = _analysisResult!;
    final newMeal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: result['name'],
      imageUrl: 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800',
      timestamp: DateTime.now(),
      calories: result['calories'] as double,
      carbs: result['carbs'] as double,
      protein: result['protein'] as double,
      fat: result['fat'] as double,
      fiber: result['fiber'] as double,
      portionSize: result['portionSize'] as double,
      eatingDuration: (10.0 + (DateTime.now().millisecond % 15)),
      eatingSpeed: (15.0 + (DateTime.now().millisecond % 20)),
    );
    
    context.read<MealProvider>().addMeal(newMeal);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Meal logged successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    
    // Navigate back to home dashboard without duplicating navigation
    Navigator.of(context).popUntil((route) => route.isFirst);
    // Then navigate to home with proper navigation wrapper
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeDashboard(),
      ),
    );
  }
}