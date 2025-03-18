import 'package:flutter/material.dart';

import '../pages/settings_page.dart';
import '../services/auth_service.dart';
import 'my_drawer_tile.dart';


class MyDrawer extends StatelessWidget {
  void logout(BuildContext context) {
    AuthService().signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 80.0),
            child: Icon(Icons.lock_open, size: 40, color: Theme.of(context).colorScheme.inversePrimary),
          ),
          Padding(
            padding: EdgeInsets.all(25.0),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),
          MyDrawerTile(icon: Icons.home, onTap: () => Navigator.pop(context), text: 'H O M E'),
          MyDrawerTile(icon: Icons.settings, onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
          }, text: 'S E T T I N G S'),
          Spacer(),
          MyDrawerTile(icon: Icons.logout, onTap: () => logout(context), text: 'L O G O U T'),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
