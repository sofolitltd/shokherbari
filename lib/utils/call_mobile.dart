import 'package:url_launcher/url_launcher.dart';

callMobile(mobile) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: mobile,
  );
  await launchUrl(launchUri);
}
