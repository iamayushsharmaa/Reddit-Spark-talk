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
  UserModel? userModel;

  void getUserData(WidgetRef ref, User data) async {
    userModel =
        await ref
            .watch(authControllerProvider.notifier)
            .getUserData(userModel!.uid)
            .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(authStateChangeProvider)
        .when(
          data:
              (data) => MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: Pallete.darkModeAppTheme,
                routerDelegate: RoutemasterDelegate(
                  routesBuilder: (context) {
                    if (data != null) {
                      getUserData(ref, data);
                      if (userModel != null) {
                        return loggedInRoute;
                      }
                    }
                    return loggedOutRoute;
                  },
                ),
                routeInformationParser: const RoutemasterParser(),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
    ;
  }
}
