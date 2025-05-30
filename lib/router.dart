import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/features/auth/screens/login_screen.dart';
import 'package:spark_talk_reddit/features/community/screens/add_mod_screen.dart';
import 'package:spark_talk_reddit/features/community/screens/community_screen.dart';
import 'package:spark_talk_reddit/features/community/screens/create_community_screen.dart';
import 'package:spark_talk_reddit/features/community/screens/edit_community_screen.dart';
import 'package:spark_talk_reddit/features/community/screens/mod_tool_screen.dart';
import 'package:spark_talk_reddit/features/home/screens/home_screen.dart';
import 'package:spark_talk_reddit/features/post/screens/add_post_screen.dart';
import 'package:spark_talk_reddit/features/post/screens/add_post_type_screen.dart';
import 'package:spark_talk_reddit/features/post/screens/comment_screen.dart';
import 'package:spark_talk_reddit/features/user_profile/screens/edit_profile_screen.dart';
import 'package:spark_talk_reddit/features/user_profile/screens/user_profile_screen.dart';

final loggedOutRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: LoginScreen())},
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community':
        (_) => const MaterialPage(child: CreateCommunityScreen()),
    'r/:name':
        (route) => MaterialPage(
          child: CommunityScreen(name: route.pathParameters['name']!),
        ),
    '/mod-tools/:name':
        (routeData) => MaterialPage(
          child: ModToolScreen(name: routeData.pathParameters['name']!),
        ),
    '/mod-community/:name':
        (routeData) => MaterialPage(
          child: EditCommunityScreen(name: routeData.pathParameters['name']!),
        ),
    '/add-mod/:name':
        (routeData) => MaterialPage(
          child: AddModScreen(name: routeData.pathParameters['name']!),
        ),
    '/u/:uid':
        (routeData) => MaterialPage(
          child: UserProfileScreen(uid: routeData.pathParameters['uid']!),
        ),
    '/edit-profile/:uid':
        (routeData) => MaterialPage(
          child: EditProfileScreen(uid: routeData.pathParameters['uid']!),
        ),
    '/add-post/:type': (routeData) => MaterialPage(
      child: AddPostTypeScreen(type: routeData.pathParameters['type']!),
    ),
    '/comment/:postId/comments': (route) => MaterialPage(
      child: CommentScreen(postId: route.pathParameters['postId']!),
    ),

    '/add-post': (routeData) => const MaterialPage(
      child: AddPostScreen(),
    ),
  },
);
