import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/problems_screen.dart';
import 'screens/dtc_screen.dart';

void main() {
  runApp(const AutoEntraideApp());
}

class AutoEntraideApp extends StatelessWidget {
  const AutoEntraideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        ChangeNotifierProxyProvider<ApiService, AuthProvider>(
          create: (context) => AuthProvider(
            AuthService(Provider.of<ApiService>(context, listen: false)),
          ),
          update: (context, apiService, previous) => previous ?? AuthProvider(
            AuthService(apiService),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Auto Entraide',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/problems',
      builder: (context, state) => const ProblemsScreen(),
    ),
    GoRoute(
      path: '/dtc',
      builder: (context, state) => const DtcScreen(),
    ),
  ],
);
