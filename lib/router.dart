

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/features/auth/screens/login_screen.dart';
import 'package:spark_talk_reddit/features/community/screens/create_community_screen.dart';
import 'package:spark_talk_reddit/features/home/screens/home_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community' : (_) => const MaterialPage(child: CreateCommunityScreen()),

});