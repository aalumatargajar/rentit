// Share app link
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareAppLink() async {
  // Get the app's package name.
  final String packageName = await PackageInfo.fromPlatform().then(
    (info) => info.packageName,
  );

  // Create the Play Store link.
  String playStoreLink =
      'https://play.google.com/store/apps/details?id=$packageName';

  // Share the Play Store link.
  await Share.share(
    'Download our app from the Google Play Store: $playStoreLink',
  );
}
