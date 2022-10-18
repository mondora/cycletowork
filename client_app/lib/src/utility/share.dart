import 'package:share_plus/share_plus.dart' as share_plus;

class Share {
  static Future shareText(String text, {String? subject}) async {
    await share_plus.Share.share(
      text,
      subject: subject,
    );
  }

  static Future shareImage(String imagePath, {String? text}) async {
    await share_plus.Share.shareFiles(
      [imagePath],
      text: text,
    );
  }
}
