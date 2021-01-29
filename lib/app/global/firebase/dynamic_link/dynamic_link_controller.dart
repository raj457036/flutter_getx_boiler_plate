import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DynamicLinkController extends GetxController {
  /// default `URI prefix` for dynamic links
  final String defaultUriPrefix;

  /// default [AndroidParameters] for dynamic links
  final AndroidParameters defaultAndroidParameters;

  /// default [IosParameters] for dynamic links
  final IosParameters defaultIosParameters;

  /// default [GoogleAnalyticsParameters] for dynamic links
  final GoogleAnalyticsParameters defaultGoogleAnalyticsParameters;

  /// default [ItunesConnectAnalyticsParameters] for dynamic links
  final ItunesConnectAnalyticsParameters
      defaultItunesConnectAnalyticsParameters;

  /// default [SocialMetaTagParameters] for dynamic links
  final SocialMetaTagParameters defaultSocialMetaTagParameters;

  /// generate short dynamic link by default
  final bool defaultShortURL;

  DynamicLinkController({
    this.defaultUriPrefix,
    this.defaultAndroidParameters,
    this.defaultIosParameters,
    this.defaultGoogleAnalyticsParameters,
    this.defaultItunesConnectAnalyticsParameters,
    this.defaultSocialMetaTagParameters,
    this.defaultShortURL = false,
  });

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _initDynamicLinks();
  }

  @override
  void onClose() {}

  /// initalizes dynamic link for this project
  ///
  /// 1. dynamic link `path` will be used to `navigate` to other pages
  /// 2. dynamic link `query parameters` will be used as `arguments` for the route
  Future<void> _initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null && !deepLink.hasEmptyPath) {
        _processDeepLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null && !deepLink.hasEmptyPath) {
      _processDeepLink(deepLink);
    }
  }

  _processDeepLink(Uri link) {
    final segments = link.pathSegments;

    try {
      final _for = segments[0];
      final _to = segments[1];
      final arguments = {"dynamic": true, ...link.queryParameters};

      if (_for == "app") {
        if (Get.currentRoute == _to)
          Get.offAndToNamed(_to, arguments: arguments);
        else
          Get.toNamed(_to, arguments: arguments);
      }
    } catch (e) {
      print(e);
      print(
          "dynamic link was not in correct format!!! launcing url in browser.");
    }
  }

  /// generate dynamic link with the provided parameters
  Future<Uri> generateDynamicLink({
    @required String url,
    String uriPrefix,
    AndroidParameters androidParameters,
    IosParameters iosParameters,
    GoogleAnalyticsParameters googleAnalyticsParameters,
    ItunesConnectAnalyticsParameters itunesConnectAnalyticsParameters,
    SocialMetaTagParameters socialMetaTagParameters,
    bool shortURL,
  }) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix ?? defaultUriPrefix,
      link: Uri.parse(url),
      androidParameters: androidParameters ?? defaultAndroidParameters,
      iosParameters: iosParameters ?? defaultIosParameters,
      googleAnalyticsParameters:
          googleAnalyticsParameters ?? defaultGoogleAnalyticsParameters,
      itunesConnectAnalyticsParameters: itunesConnectAnalyticsParameters ??
          defaultItunesConnectAnalyticsParameters,
      socialMetaTagParameters:
          socialMetaTagParameters ?? defaultSocialMetaTagParameters,
    );

    if (shortURL ?? defaultShortURL) {
      final ShortDynamicLink shortDynamicLink =
          await parameters.buildShortLink();
      final Uri shortUrl = shortDynamicLink.shortUrl;
      return shortUrl;
    } else {
      final Uri dynamicUrl = await parameters.buildUrl();
      return dynamicUrl;
    }
  }

  /// Utility method to generate a short link for an url
  Future<Uri> shortLink(String url) async {
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      Uri.parse(url),
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable,
      ),
    );

    final Uri shortUrl = shortenedLink.shortUrl;
    return shortUrl;
  }
}
