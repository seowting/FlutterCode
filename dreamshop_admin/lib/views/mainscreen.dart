import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DreamShop'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Seow Ting"),
              accountEmail: Text("seowting@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn.myanimelist.net/r/360x360/images/characters/9/310307.jpg?s=56335bffa6f5da78c3824ba0dae14a26"),
              ),
            ),
            _createDrawerItem(
              icon: Icons.abc,
              text: 'Products',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.shopping_bag,
              text: 'Products',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.shopping_cart,
              text: 'Cart',
              onTap: () {},
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Hello World'),
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
