import 'package:url_launcher/url_launcher.dart';

callMobileAdmin(mobile) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: mobile,
  );
  await launchUrl(launchUri);
}
