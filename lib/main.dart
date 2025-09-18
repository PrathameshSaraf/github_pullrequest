import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'BLOC/Login/Login_bloc.dart';
import 'Core/app_colors.dart' show AppColors;
import 'Data/Services/LoginService.dart';
import 'Presentation/Screens/LoginScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.violet),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Login BLoC',
      theme: theme,
      home: BlocProvider(
        create: (_) => LoginBloc(AuthService()),
        child: const LoginScreen(),
      ),
    );
  }
}
