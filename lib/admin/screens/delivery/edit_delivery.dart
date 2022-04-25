import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shokher_bari/utils/constrains.dart';

class EditDelivery extends StatefulWidget {
  final int? charge;
  const EditDelivery({Key? key, this.charge}) : super(key: key);

  @override
  State<EditDelivery> createState() => _EditDeliveryState();
}

class _EditDeliveryState extends State<EditDelivery> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _chargeController = TextEditingController();
  bool isUpload = false;

  @override
  void initState() {
    if (widget.charge != null) {
      _chargeController.text = widget.charge.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _chargeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Delivery Charge'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: _chargeController,
                decoration: const InputDecoration(
                  hintText: 'Delivery Charge',
                  label: Text('Delivery Charge'),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Enter delivery charge' : null,
              ),
            ),

            // save
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  if (_globalKey.currentState!.validate()) {
                    //start loading
                    setState(() => isUpload = true);

                    //
                    MyRepo.ref.collection('Extra').doc('Delivery').set({
                      'charge': int.parse(_chargeController.text)
                    }).then((value) {
                      Fluttertoast.showToast(msg: 'Upload Delivery Charge');

                      //stop loading
                      setState(() => isUpload = false);

                      //
                      Navigator.pop(context);
                    });
                  }
                },
                child: isUpload
                    ? const CircularProgressIndicator(color: Colors.red)
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
