import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:pomodoro/timercount.dart';

class DrawerPage extends StatefulWidget {
  final AdvancedDrawerController advancedDrawerController;
  const DrawerPage({super.key, required this.advancedDrawerController});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      width: size.width * 0.6,
      height: size.height * 0.9,
      child: ListTileTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        style: ListTileStyle.drawer,
        tileColor: Theme.of(context).primaryColorDark,
        iconColor: Theme.of(context).primaryColor,
        textColor: Theme.of(context).primaryColor,
        contentPadding: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).primaryColorLight),
                  image: const DecorationImage(
                      image: AssetImage("lib/photos/KZT.jpg")),
                  borderRadius: BorderRadius.circular(20)),
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "Kaung Zaw Thant\n\n",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const TextSpan(
                  text: "Level 1",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold))
            ])),
            ListTile(
              onTap: () {},
              leading: const Icon(FluentIcons.person_accounts_24_regular),
              title: const Text(
                "My Account",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                widget.advancedDrawerController.hideDrawer();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const TimeCount())));
              },
              leading: const Icon(FluentIcons.history_24_regular),
              title: const Text("Pomodoro List",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(FluentIcons.settings_24_regular),
              title: const Text("Settings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(FluentIcons.contact_card_24_regular),
              title: const Text("Contact Us",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
