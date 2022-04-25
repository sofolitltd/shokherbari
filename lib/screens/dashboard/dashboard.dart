import 'package:flutter/material.dart';

import '/screens/cart/cart.dart';
import '/screens/home/home.dart';
import '/screens/profile/profile.dart';
import '/screens/wishlist/wishlist_screen.dart';
import '../order/order.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List _screen = [
    const Home(),
    const Wishlist(),
    const Cart(),
    const Order(),
    const Profile(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          //
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          //
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),

          //
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),

          //
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Orders',
          ),

          //
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),

      //
      body: _screen[_selectedIndex],
    );
  }
}
