import 'package:flutter/material.dart';
import 'package:shokher_bari/provider/address_provider.dart';
import 'package:shokher_bari/utils/constrains.dart';

import '../../../../models/address_book.dart';

class AddressHome extends StatefulWidget {
  const AddressHome({Key? key}) : super(key: key);

  @override
  _AddressHomeState createState() => _AddressHomeState();
}

class _AddressHomeState extends State<AddressHome> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          //
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: [
                // name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Full Name'),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter some text' : null,
                ),

                const SizedBox(height: 8),

                // mobile
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    counterText: "",
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  maxLength: 11,
                  validator: (value) => value!.isEmpty
                      ? 'Please enter some text'
                      : value.length < 11
                          ? 'Phone number must be 11 digits'
                          : null,
                ),

                const SizedBox(height: 8),

                // area
                TextFormField(
                  controller: _areaController,
                  decoration: const InputDecoration(hintText: 'Area'),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter some text' : null,
                ),

                const SizedBox(height: 8),

                // address
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(hintText: 'Address'),
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter some text' : null,
                ),

                const SizedBox(height: 16),

                // label
                // buildAddressLabel(),
              ],
            ),
          ),

          // save
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SizedBox(
              height: 48,
              child: _isLoading
                  ? const OutlinedButton(
                      onPressed: null,
                      child: CircularProgressIndicator(color: Colors.red),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          setState(() => _isLoading = true);

                          AddressModel _address = AddressModel(
                            name: _nameController.text.trim(),
                            phone: _phoneController.text,
                            address: _addressController.text.trim(),
                            place: _areaController.text.trim(),
                          );

                          await AddressProvider.addAddress(
                              MyRepo.refAddressHome, _address.toJson());

                          setState(() => _isLoading = false);

                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
