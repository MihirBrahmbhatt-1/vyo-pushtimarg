class DailySevaPranalikaResponseModel {
  String? sevaDate;
  String? tithiMatch;
  String? miti;
  String? vastra;
  String? mastak;
  String? aabharan;
  String? specialVastra;
  String? specialUtsav;
  SevaPranalika? sevaPranalika;
  List<AppUpdates>? appUpdates;
  String? notificationDetail;

  DailySevaPranalikaResponseModel(
      {this.sevaDate,
      this.tithiMatch,
      this.miti,
      this.vastra,
      this.mastak,
      this.aabharan,
      this.specialVastra,
      this.specialUtsav,
      this.sevaPranalika,
      this.appUpdates,
      this.notificationDetail,});

  DailySevaPranalikaResponseModel.fromJson(Map<String, dynamic> json) {
    sevaDate = json['seva_date'];
    tithiMatch = json['tithi_match'];
    miti = json['miti'];
    vastra = json['vastra'];
    mastak = json['mastak'];
    aabharan = json['aabharan'];
    specialVastra = json['special_vastra'];
    specialUtsav = json['special_utsav'];
    sevaPranalika = json['seva_pranalika'] != null
        ? SevaPranalika.fromJson(json['seva_pranalika'])
        : null;
    if (json['app_updates'] != null) {
      appUpdates = <AppUpdates>[];
      json['app_updates'].forEach((v) {
        appUpdates!.add(AppUpdates.fromJson(v));
      });
    }
    notificationDetail = json['notification_detail'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seva_date'] = sevaDate;
    data['tithi_match'] = tithiMatch;
    data['miti'] = miti;
    data['vastra'] = vastra;
    data['mastak'] = mastak;
    data['aabharan'] = aabharan;
    data['special_vastra'] = specialVastra;
    data['special_utsav'] = specialUtsav;
    if (sevaPranalika != null) {
      data['seva_pranalika'] = sevaPranalika!.toJson();
    }
    if (appUpdates != null) {
      data['app_updates'] = appUpdates!.map((v) => v.toJson()).toList();
    }
    data['notification_detail'] = notificationDetail;
    return data;
  }
}

class SevaPranalika {
  String? sevaDate;
  String? tithiMatch;
  String? miti;
  String? vastra;
  String? mastak;
  String? aabharan;
  String? specialVastra;
  String? specialUtsav;

  SevaPranalika(
      {this.sevaDate,
      this.tithiMatch,
      this.miti,
      this.vastra,
      this.mastak,
      this.aabharan,
      this.specialVastra,
      this.specialUtsav});

  SevaPranalika.fromJson(Map<String, dynamic> json) {
    sevaDate = json['seva_date'];
    tithiMatch = json['tithi_match'];
    miti = json['miti'];
    vastra = json['vastra'];
    mastak = json['mastak'];
    aabharan = json['aabharan'];
    specialVastra = json['special_vastra'];
    specialUtsav = json['special_utsav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seva_date'] = sevaDate;
    data['tithi_match'] = tithiMatch;
    data['miti'] = miti;
    data['vastra'] = vastra;
    data['mastak'] = mastak;
    data['aabharan'] = aabharan;
    data['special_vastra'] = specialVastra;
    data['special_utsav'] = specialUtsav;
    return data;
  }
}

class AppUpdates {
  String? appOsType;
  String? url;
  bool? isDisplay;
  bool? forceUpdate;
  String? minimumVersion;
  String? currentVersion;

  AppUpdates({this.appOsType, this.url, this.isDisplay, this.forceUpdate, this.minimumVersion, this.currentVersion,});

  AppUpdates.fromJson(Map<String, dynamic> json) {
    appOsType = json['app_os_type'];
    url = json['url'];
    isDisplay = json['is_display'];
    forceUpdate = json['force_update'];
    minimumVersion = json['minimum_version'];
    currentVersion = json['current_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_os_type'] = appOsType;
    data['url'] = url;
    data['is_display'] = isDisplay;
    data['force_update'] = forceUpdate;
    data['minimum_version'] = minimumVersion;
    data['current_version'] = currentVersion;
    return data;
  }
}
