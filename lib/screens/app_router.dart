import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_movie_app/bloc/authentication/auth_bloc.dart';
import 'package:gdsc_movie_app/bloc/authentication/auth_state.dart';
import 'package:gdsc_movie_app/bloc/authentication/signup_bloc.dart';
import 'package:gdsc_movie_app/repositories/firebase/user_repository.dart';
import 'package:gdsc_movie_app/screens/authentication/signin_screen.dart';
import 'package:gdsc_movie_app/screens/authentication/signup_screen.dart';
import 'package:gdsc_movie_app/screens/home/home.dart';
import 'package:gdsc_movie_app/screens/profile/profile_screen.dart';
import 'package:gdsc_movie_app/screens/search/search_screen.dart';
import 'package:gdsc_movie_app/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Routing
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/signin',
          builder: (context, state) => const SigninScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => BlocProvider(
            create: (context) => SignupBloc(
              user: context.read<AuthBloc>().state.user,
              userRepository: context.read<UserRepository>(),
              storage: FirebaseStorage.instance,
            ),
            child: SignupScreen(),
          ),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
          redirect: (context, state) {
            final authStatus = context.read<AuthBloc>().state.status;
            if (authStatus == AuthStatus.unauthenticated) {
              return '/signup';
            }
            return state.path;
          },
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'GDSC Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
    );
  }
}
