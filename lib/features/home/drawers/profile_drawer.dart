import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/features/auth/controller/auth_controller.dart';
import 'package:spark_talk_reddit/theme/pallete.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref){
    ref.watch(authControllerProvider.notifier).logOut();
  }
  void navigateToProfile(BuildContext context, String uid){
    Routemaster.of(context).push('/u/${uid}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 40,
            ),
            const SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                navigateToProfile(context, user.uid);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Pallete.redColor),
              title: const Text('Log Out'),
              onTap: () => logOut(ref),
            ),
            Switch.adaptive(value: true, onChanged: (value) {}),
          ],
        ),
      ),
    );
  }
}
