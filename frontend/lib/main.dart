import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/config/theme.dart';
import 'services/storage_service.dart';
import 'providers/auth_provider.dart';
import 'providers/sites_provider.dart';
import 'providers/itineraires_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/sites/sites_list_screen.dart';
import 'screens/culture/culture_screen.dart';
import 'screens/itineraires/itineraires_list_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // StorageService expose ensuite SharedPreferences de façon synchrone,
  // il doit donc être prêt avant le premier écran.
  await StorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SitesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ItinerairesProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Bãng Zĩiga',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/sites': (context) => const SitesListScreen(),
          '/culture': (context) => const CultureScreen(),
          '/itineraires': (context) => const ItinerairesListScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          );
        },
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: const _CustomScrollBehavior(),
            child: child!,
          );
        },
      ),
    );
  }
}

// Supprime le halo de fin de défilement d'Android et impose un rebond de type
// iOS sur toutes les listes de l'application.
class _CustomScrollBehavior extends ScrollBehavior {
  const _CustomScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
