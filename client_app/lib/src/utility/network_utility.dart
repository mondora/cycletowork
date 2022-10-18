import 'package:http/http.dart' as http;

/// The Network Utility
class NetworkUtility {
  static Future<String?> fetchUrl(
    Uri uri, {
    Map<String, String>? headers,
    Duration timeout = const Duration(milliseconds: 3000),
  }) async {
    final response = await http
        .get(
          uri,
          headers: headers,
        )
        .timeout(timeout);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  /// Creates a uri with the proxy url if it is set
  /// [proxyUrl] Required parameters - can be formatted as [https://]host[:<port>][/<path>][?<url-param-name>=] only https proxies are supported.
  /// [authority] Required parameters - the domain name of the server, usually https://maps.googleapis.com
  /// [unencodedPath] Required parameters - the path to the api, usually something like maps/api/...
  /// [queryParameters] Required parameters - a map of query parameters to be appended to the url
  static Uri createUri(
    String? proxyUrl,
    String authority,
    String unencodedPath,
    Map<String, String?> queryParameters,
  ) {
    Uri uri;
    final apiUri = Uri.https(
      authority,
      unencodedPath,
      queryParameters,
    );

    if (proxyUrl != null && proxyUrl != '') {
      bool usingHttps = true;
      String everythingAfterHostname = '';
      String proxyHostname = proxyUrl;
      if (proxyUrl.startsWith('https://')) {
        proxyHostname = proxyUrl.replaceFirst("https://", "");
        usingHttps = true;
      } else if (proxyUrl.startsWith('http://')) {
        proxyHostname = proxyUrl.replaceFirst("http://", "");
        usingHttps = false;
      }

      if (proxyHostname.contains("/")) {
        everythingAfterHostname =
            proxyHostname.substring(proxyHostname.indexOf("/"));
        proxyHostname = proxyHostname.substring(0, proxyHostname.indexOf("/"));
      }

      if (everythingAfterHostname.contains("?") &&
          everythingAfterHostname.contains("=")) {
        var proxyPath = everythingAfterHostname.substring(
            0, everythingAfterHostname.indexOf("?"));
        var parameterName = everythingAfterHostname.substring(
            everythingAfterHostname.indexOf("?") + 1,
            everythingAfterHostname.indexOf("="));
        var urlParam = {parameterName: apiUri.toString()};
        queryParameters.addAll(urlParam);
        if (usingHttps) {
          uri = Uri.https(
            proxyHostname,
            proxyPath,
            queryParameters,
          );
        } else {
          uri = Uri.http(
            proxyHostname,
            proxyPath,
            queryParameters,
          );
        }
      } else {
        //no parameter
        if (usingHttps) {
          uri = Uri.https(
            proxyHostname,
            '${everythingAfterHostname}https://$authority/$unencodedPath',
            queryParameters,
          );
        } else {
          uri = Uri.http(
            proxyHostname,
            '${everythingAfterHostname}http://$authority/$unencodedPath',
            queryParameters,
          );
        }
      }
    } else {
      uri = apiUri;
    }
    // print(uri.toString());
    return uri;
  }
}
