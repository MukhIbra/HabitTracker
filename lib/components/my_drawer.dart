import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(child: Icon(Icons.calendar_month, size: 50)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: ListTile(
                title: const Text('H O M E'),
                leading: const Icon(Icons.home),
                onTap: Navigator.of(context).pop,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: ListTile(
                title: const Text('S E T T I N G S'),
                leading: const Icon(Icons.settings),
                onTap: () {
                  Navigator.of(context).pop();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ));
                },
              ),
            )
          ],
        ));
  }
}
