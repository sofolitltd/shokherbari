import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/admin/screens/delivery/edit_delivery.dart';

import '/utils/constrains.dart';

class DeliveryAdmin extends StatelessWidget {
  const DeliveryAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Charge'),
      ),

      //
      body: StreamBuilder<DocumentSnapshot>(
        stream: MyRepo.ref.collection('Extra').doc('Delivery').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!;

          if (!data.exists) {
            return const Center(child: Text('No delivery charge found'));
          }

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Row(
                children: [
                  const Text(
                    'Delivery Charge:',
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$kTk ${data.get('charge')}',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditDelivery(charge: data.get('charge'))));
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          );
        },
      ),
    );
  }
}
