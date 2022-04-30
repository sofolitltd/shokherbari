import 'package:shokher_bari/admin/models/order_model_admin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/address_book.dart';

mailSendAdmin(OrderModelAdmin order, AddressModel address) async {
  final Uri launchUri = Uri(
    scheme: 'mailto',
    path: order.email,
    query:
        'subject= Your order on Shokher Bari has been received! &body= Hi ${address.name},'
        '\n\n Thanks for your order. Your order is on its way. Your order details can be found below'
        '\n\nORDER SUMMARY:'
        '\n\nOrder: #${order.orderId}'
        '\nPayment Method: ${order.method}'
        '\nOrder Total: ${order.total}'
        '\n\nSHIPPING ADDRESS: '
        '\n\nName: ${address.name}'
        '\nMobile No: ${address.phone}'
        '\nAddress: ${address.address}'
        '\nPlace: ${address.place}',
  );
  await launchUrl(launchUri);
}
