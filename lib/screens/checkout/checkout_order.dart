import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

import '/screens/dashboard/dashboard.dart';

class CheckoutOrder extends StatelessWidget {
  const CheckoutOrder({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Dashboard()),
                  (_) => false);
            },
            icon: const Icon(Icons.home)),
        title: const Text('Checkout (3/3)'),
      ),

      //
      body: Column(
        children: [
          // stepper
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 48,
                  child: IconStepper(
                    enableNextPreviousButtons: false,
                    activeStepBorderWidth: 2,
                    stepColor: Colors.transparent,
                    activeStepColor: Colors.transparent,
                    activeStepBorderColor: Colors.transparent,
                    activeStepBorderPadding: 0,
                    lineColor: Colors.grey,
                    lineLength: 85,
                    lineDotRadius: 2,
                    icons: const [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.black87,
                      ),
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.black87,
                      ),
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Delivery address',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Payment method',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Order placed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const Divider(),

          // select address
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 32),
              child: Column(
                children: [
                  Text(
                    'Order placed successfully',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  //
                  Text(
                    'Congratulations. Your order successfully placed.',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  //
                  Text(
                    'You can track your order number  ',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  //
                  SelectableText(
                    uid,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Colors.orange,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          //
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Dashboard()),
                    (_) => false);
              },
              child: const Text('Continue shopping'),
            ),
          ),
        ],
      ),
    );
  }
}
