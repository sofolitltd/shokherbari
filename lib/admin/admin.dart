import 'package:flutter/material.dart';
import 'package:shokher_bari/admin/utils/constraints.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.description), label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag), label: 'Products'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: 'Categories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on_rounded), label: 'Delivery'),
          ],
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.blue.shade200,
          currentIndex: selectedIndex,
          onTap: (newIndex) {
            setState(() => selectedIndex = newIndex);
          },
        ),

        //
        body: AdminRepo.screenList[selectedIndex]);
  }
}
