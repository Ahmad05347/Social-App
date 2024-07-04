import 'package:flutter/material.dart';
import 'package:socialmedia_app/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final Function()? onProfile;
  final Function()? logout;
  const MyDrawer({super.key, required this.logout, required this.onProfile});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MyListTile(
                icon: Icons.home_max_rounded,
                text: "H O M E",
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: MyListTile(
              icon: Icons.logout_rounded,
              text: "L O G O U T",
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
