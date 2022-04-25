import 'package:fluttertoast/fluttertoast.dart';

class AddressProvider {
  //addAddress
  static addAddress(refAddress, address) async {
    await refAddress.set(address).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Address add successfully');
    });
  }
}
