import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/core/constant/constants.dart';
import 'package:spark_talk_reddit/features/auth/controller/auth_controller.dart';
import 'package:spark_talk_reddit/features/home/delegates/search_communities_delegate.dart';
import 'package:spark_talk_reddit/features/home/drawers/community_list_drawer.dart';
import 'package:spark_talk_reddit/features/home/drawers/profile_drawer.dart';
import 'package:spark_talk_reddit/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  void navigateToAddScreen() {
    Routemaster.of(context).push('/add-post');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => displayDrawer(context),
              icon: const Icon(Icons.menu),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchCommunityDelegate(ref),
              );
            },
            icon: const Icon(Icons.search),
          ),
          if (kIsWeb)
            IconButton(
              onPressed: () => navigateToAddScreen(),
              icon: Icon(Icons.add),
            ),
          IconButton(
            onPressed: () => displayEndDrawer(context),
            icon: CircleAvatar(backgroundImage: NetworkImage(user.profilePic)),
          ),
        ],
      ),
      body: Constants.tabWidget[_page],
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      bottomNavigationBar:
          isGuest || kIsWeb
              ? null
              : CupertinoTabBar(
                activeColor: currentTheme.iconTheme.color,
                backgroundColor: currentTheme.scaffoldBackgroundColor,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                  BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
                ],
                onTap: onPageChanged,
                currentIndex: _page,
              ),
    );
  }
}
