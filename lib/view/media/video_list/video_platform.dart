enum VideoPlatform {
  youtube,
  instagram,
  facebook,
  tiktok,
  twitter,
  vimeo,
  direct,
  unknown,
}

VideoPlatform detectVideoPlatform(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return VideoPlatform.unknown;

  final host = uri.host.toLowerCase();

  if (host.contains('youtube.com') || host.contains('youtu.be')) {
    return VideoPlatform.youtube;
  }
  if (host.contains('instagram.com')) {
    return VideoPlatform.instagram;
  }
  if (host.contains('facebook.com') || host.contains('fb.watch')) {
    return VideoPlatform.facebook;
  }
  if (host.contains('tiktok.com')) {
    return VideoPlatform.tiktok;
  }
  if (host.contains('twitter.com') || host.contains('x.com')) {
    return VideoPlatform.twitter;
  }
  if (host.contains('vimeo.com')) {
    return VideoPlatform.vimeo;
  }

  return VideoPlatform.direct;
}
 