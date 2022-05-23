import 'package:flutter/material.dart';
import 'package:mytutor/views/loginscreen.dart';

import '../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY Tutor',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.name.toString()),
              accountEmail: Text(widget.user.email.toString()),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://www.disneyplusinformer.com/wp-content/uploads/2021/12/Encanto-Avatar.png"),
              ),
            ),
            _createDrawerItem(
              icon: Icons.school,
              text: 'Find Tutor',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.subject,
              text: 'Find Subject',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.calendar_month,
              text: 'My Appointment',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.home,
              text: 'My Profile',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScreen()))
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome to MY Tutor',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red)),
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
