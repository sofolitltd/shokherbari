import 'package:flutter/material.dart';

import 'components/address_hall.dart';
import 'components/address_home.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Address'),
          bottom: const TabBar(
            tabs: [
              //
              Tab(
                text: 'Hall',
                icon: Icon(Icons.account_balance),
              ),

              //
              Tab(
                text: 'Home',
                icon: Icon(Icons.home),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            //hall
            AddressHall(),

            //home
            AddressHome(),
          ],
        ),
      ),
    );
  }
}
