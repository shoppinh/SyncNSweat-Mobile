import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationDrawer extends StatelessWidget {
  const MainNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0BA37F)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text('SyncNSweat', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          _DrawerTile(
            title: 'Home',
            icon: Icons.home,
            route: '/home',
          ),
          _DrawerTile(
            title: 'History',
            icon: Icons.history,
            route: '/history',
          ),
          _DrawerTile(
            title: 'Settings',
            icon: Icons.settings,
            route: '/settings',
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({required this.title, required this.icon, required this.route});

  final String title;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        context.go(route);
      },
    );
  }
}
