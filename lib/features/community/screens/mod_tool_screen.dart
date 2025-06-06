import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolScreen extends StatelessWidget {
  final String name;

  const ModToolScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void navigateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mod tools')),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: Text('Add Moderator'),
            onTap: () {
              navigateToAddMods(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text('Edit Community'),
            onTap: () {
              navigateToModTools(context);
            },
          ),
        ],
      ),
    );
  }
}
