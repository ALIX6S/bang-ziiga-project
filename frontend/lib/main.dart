import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Configuration
import 'core/config/theme.dart';


// Services
import 'services/storage_service.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/sites_provider.dart';
import 'providers/itineraires_provider.dart';

// Screens
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/sites/sites_list_screen.dart';
import 'screens/culture/culture_screen.dart';
import 'screens/itineraires/itineraires_list_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() async {
  // S'assurer que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration de l'orientation (portrait uniquement)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configuration de la barre de statut
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // Initialiser le service de stockage
  await StorageService.init();

  // Lancer l'application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider d'authentification
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        // Provider des sites touristiques
        ChangeNotifierProvider(
          create: (_) => SitesProvider(),
        ),

        // Provider des itinéraires
        ChangeNotifierProvider(
          create: (_) => ItinerairesProvider(),
        ),
      ],
      child: MaterialApp(
        // Configuration de base
        title: 'Bãng Zĩiga',
        debugShowCheckedModeBanner: false,

        // Thème
        theme: AppTheme.lightTheme,

        // Écran initial
        home: const SplashScreen(),

        // Routes nommées
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

        // Gestion des routes inconnues
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          );
        },

        // Configuration des transitions
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

// Comportement de scroll personnalisé (enlève le glow sur Android)
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