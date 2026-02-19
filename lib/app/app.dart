import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/home/presentation/home_page.dart';

class NumericalComputingApp extends StatelessWidget {
  const NumericalComputingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Numerical Computing',
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}
