import 'package:flutter/material.dart';
import 'package:shokher_bari/provider/address_provider.dart';
import 'package:shokher_bari/utils/constrains.dart';

import '../../../../models/address_book.dart';

class AddressHall extends StatefulWidget {
  const AddressHall({Key? key}) : super(key: key);

  @override
  _AddressHallState createState() => _AddressHallState();
}

class _AddressHallState extends State<AddressHall> {
  final List<String> _hallList = [
    'Bangabandhu Sheikh Mujibur Rahman Hall',
    'Sheikh Hasina Hall',
  ];

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedHall;
  final _roomController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _roomController.dispose();
    _selectedHall = null;
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
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),

                const SizedBox(height: 12),

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
                      ? 'Please enter phone number'
                      : value.length < 11
                          ? 'Phone number must be 11 digits'
                          : null,
                ),

                const SizedBox(height: 12),

                // hall
                DropdownButtonFormField(
                  isExpanded: true,
                  hint: const Text('Select Your Hall'),
                  items: _hallList
                      .map((item) => DropdownMenuItem<String>(
                          value: item, child: Text(item)))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedHall = value!;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select your hall' : null,
                ),

                const SizedBox(height: 12),

                // room
                TextFormField(
                  controller: _roomController,
                  decoration: const InputDecoration(
                    hintText: 'Room No',
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  maxLength: 3,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => value!.isEmpty
                      ? 'Please enter room number'
                      : value.length < 3
                          ? 'Room number must be 3 digits'
                          : null,
                ),
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
                            address: 'Room ' + _roomController.text.trim(),
                            place: _selectedHall.toString(),
                          );

                          //addAddress
                          await AddressProvider.addAddress(
                              MyRepo.refAddressHall, _address.toJson());

                          //
                          setState(() => _isLoading = false);

                          //
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
