import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/core/common/error_text.dart';
import 'package:spark_talk_reddit/core/common/loader.dart';
import 'package:spark_talk_reddit/features/auth/controller/auth_controller.dart';
import 'package:spark_talk_reddit/models/user_model.dart';
import 'package:spark_talk_reddit/router.dart';
import 'package:spark_talk_reddit/theme/pallete.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ref.watch(themeNotifierProvider),
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          final authState = ref.watch(authStateChangeProvider);
          return authState.when(
            data: (user) {
              if (user == null) {
                return loggedOutRoute;
              } else {
                final userData = ref.watch(userProvider);
                if (userData == null) {
                  // Fetch user data and navigate when ready
                  ref
                      .read(authControllerProvider.notifier)
                      .getUserData(user.uid)
                      .first
                      .then((userModel) {
                    ref.read(userProvider.notifier).update((state) => userModel);
                    Routemaster.of(context).replace('/');
                  }).catchError((error) {
                    Routemaster.of(context).replace('/error?message=$error');
                  });
                  return RouteMap(
                    routes: {'/': (_) => const MaterialPage(child: Loader())},
                  );
                }
                // User is authenticated and user data is available
                return loggedInRoute;
              }
            },
            error: (error, stackTrace) => RouteMap(
              routes: {
                '/': (_) => MaterialPage(child: ErrorText(error: error.toString())),
              },
            ),
            loading: () => RouteMap(
              routes: {'/': (_) => const MaterialPage(child: Loader())},
            ),
          );
        },
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}