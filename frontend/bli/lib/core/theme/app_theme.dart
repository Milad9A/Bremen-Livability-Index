import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Colors.teal;
  static final Color primaryDark = Colors.teal[800]!;
  static final Color primaryLight = Colors.teal[400]!;

  // Neutral Palette
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static final Color greyDark = Colors.grey[700]!;
  static final Color greyMedium = Colors.grey[600]!;
  static final Color greyLight = Colors.grey[200]!;
  static const Color transparent = Colors.transparent;

  // Semantic Colors
  static final Color error = Colors.red[900]!;
  static final Color errorBackground = Colors.red[50]!;
  static const Color warning = Colors.orange;

  static const Color success = Colors.green;
  static final Color successDark = Colors.green[700]!;
  static final Color successLight = Colors.green.withValues(alpha: 0.1);

  static final Color errorDark = Colors.red[700]!;
  static final Color errorLight = Colors.red.withValues(alpha: 0.1);

  static final Color scoreHigh = Colors.teal[700]!;
  static final Color scoreMedium = Colors.orange[800]!;
  static final Color scoreLow = Colors.red[700]!;

  // Glassmorphism
  static final Color glassBorder = white.withValues(alpha: 0.2);
  static final Color glassBackground = white.withValues(alpha: 0.65);

  // Feature Colors
  static const Color featureGreenery = Colors.green;
  static const Color featureAmenities = Colors.blue;
  static final Color featureTransport =
      Colors.blue[900]!; // Dark Blue instead of Indigo/Purple
  static const Color featureHealthcare = Colors.red;
  static const Color featureSafety = Colors.orange;

  static const Color featureEducation = Colors.cyan; // Replaces Purple
  static const Color featureCultural = Colors.teal; // Replaces Pink
  static const Color featureBike = Colors.teal;
  static const Color featureSports = Colors.amber;
  static const Color featurePedestrian = Colors.lightGreen;
  static const Color featureNoise = Colors.deepOrange;
  static final Color featureRailway = Colors.blueGrey[700]!;
  static const Color featureWaste = Colors.brown;
  static final Color featurePower = Colors.yellow[800]!;
  static const Color featureParking = Colors.grey;
  static const Color featureConstruction = Colors.orangeAccent;
  static const Color featureIndustrial = Colors.grey;
  static final Color featureRoad = Colors.black.withValues(alpha: 0.54);
  static final Color featureUnknown = greyLight;
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.greyDark,
  );

  static final TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.greyDark,
  );

  static final TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.greyMedium,
  );

  static final TextStyle hint = TextStyle(
    color: AppColors.greyDark,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.teal,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      useMaterial3: true,

      iconTheme: IconThemeData(color: AppColors.primaryDark),

      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyles.hint,
        border: InputBorder.none,
        prefixIconColor: AppColors.primaryDark,
        suffixIconColor: AppColors.greyMedium,
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withValues(alpha: 0.3),
        selectionHandleColor: AppColors.primary,
      ),
    );
  }
}
