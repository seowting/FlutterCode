import 'package:flutter/material.dart';
import 'package:mytutor/views/loginscreen.dart';
import 'package:mytutor/views/subjectsscreen.dart';
import 'package:mytutor/views/tutorsscreen.dart';

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
  late double screenHeight, screenWidth, ctrwidth;
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    SubjectsScreen(),
    TutorsScreen(),
    Text(
      'Subscribe',
      style: optionStyle,
    ),
    Text(
      'Favourite',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
    }

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
              icon: Icons.subject,
              text: 'Subjects',
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const SubjectsScreen()))
              },
            ),
            _createDrawerItem(
              icon: Icons.school,
              text: 'Tutors',
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const TutorsScreen()))
              },
            ),
            _createDrawerItem(
              icon: Icons.calendar_month,
              text: 'Subscribe',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.star,
              text: 'Favourite',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.person,
              text: 'Profile',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () => {
                _logoutDialog(),
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.subject), label: 'Subjects'),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Tutors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Subscribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Logout",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const LoginScreen()));
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
