import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/portfolio_screen.dart';
import 'screens/project_detail_screen.dart';
import 'models/portfolio_data.dart';
import 'theme/app_colors.dart';
import 'screens/auth_callback_screen.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Anuket | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const PortfolioScreen(),
          ),
          GoRoute(
            path: '/project/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProjectDetailScreen(projectId: id);
            },
          ),
          GoRoute(
            path: '/callback',
            builder: (context, state) => const AuthCallbackPage(),
          ),
        ],
      ),
    );
  }
}
