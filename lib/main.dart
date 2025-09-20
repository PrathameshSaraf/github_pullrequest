import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BLOC/Login/Login_bloc.dart';
import 'Core/app_colors.dart' show AppColors;
import 'Data/Services/LoginService.dart';
import 'Presentation/Screens/LoginScreen.dart';
import 'Presentation/Screens/HomeScreen.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:Size(360, 690), // iPhone X design size (you can adjust this)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final theme = ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.violet),
          useMaterial3: true,
        );

        return MaterialApp(
          title: 'Login BLoC',
          theme: theme,
          home: const SplashWrapper(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;

      // Add a small delay for splash effect (optional)
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;

      if (isUserLoggedIn) {
        // Navigate to Home Screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Navigate to Login Screen with BLoC
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => LoginBloc(AuthService()),
              child: const LoginScreen(),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle error - default to login screen
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => LoginBloc(AuthService()),
            child: const LoginScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.violet,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can add your app logo here
            Icon(
              Icons.login,
              size: 80.w, // Using ScreenUtil for responsive sizing
              color: Colors.white,
            ),
            SizedBox(height: 20.h), // Using ScreenUtil for responsive spacing
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp, // Using ScreenUtil for responsive text
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30.h),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}