import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/splash_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Wrap the app with ProviderScope to enable Riverpod
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive design
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 13 Pro size as base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'LensHive',
          debugShowCheckedModeBanner: false,
      
          // Light theme configuration
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0A83BC), // Professional Blue
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: Colors.white,
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
          ),
      
          // Dark theme configuration - Professional & Elegant
          // darkTheme: ThemeData(
          //   useMaterial3: true,
          //   brightness: Brightness.dark,
          //   colorScheme: const ColorScheme.dark(
          //     primary: Color(0xFF00D9FF), // Elegant Cyan
          //     secondary: Color(0xFF7C3AED), // Deep Purple accent
          //     surface: Color(0xFF1E1E2E), // Deep charcoal surface
          //     background: Color(0xFF0F0F1A), // Very dark background
          //     onPrimary: Color(0xFF000000), // Black text on primary
          //     onSecondary: Colors.white,
          //     onSurface: Color(0xFFE4E4E7), // Soft white for text
          //     onBackground: Color(0xFFE4E4E7),
          //     error: Color(0xFFFF6B6B),
          //   ),
          //   scaffoldBackgroundColor: const Color(0xFF0F0F1A),
          //   cardColor: const Color(0xFF1E1E2E),
          //   appBarTheme: const AppBarTheme(
          //     centerTitle: true,
          //     elevation: 0,
          //     backgroundColor: Color(0xFF0F0F1A),
          //   ),
          // ),
      
          // Use system theme mode (automatically switches based on device settings)
          themeMode: ThemeMode.system,
      
          // Start with splash screen
          home: const SplashScreen()
        );
      },
    );
  }
}
