class DailySevaPranalikaResponseModel {
  String? date;
  String? tithiMatch;
  String? miti;
  String? vastra;
  String? mastak;
  String? aabharan;
  String? specialVastra;
  String? specialUtsav;
  String? mitiEmoji;
  String? dateEmoji;

  DailySevaPranalikaResponseModel({
    this.date,
    this.tithiMatch,
    this.miti,
    this.vastra,
    this.mastak,
    this.aabharan,
    this.specialVastra,
    this.specialUtsav,
    this.mitiEmoji,
    this.dateEmoji,
  });

  DailySevaPranalikaResponseModel.fromJson(Map<String, dynamic> json) {
    date = json['seva_date'];
    tithiMatch = json['tithi_match'];
    miti = json['miti'] ?? '';
    vastra = json['vastra'] ?? '';
    mastak = json['mastak'] ?? '';
    aabharan = json['aabharan'];
    specialVastra = json['special_vastra'] ?? '';
    specialUtsav = json['special_utsav'] ?? '';
    mitiEmoji = json['miti_emoji'] ?? '';
    dateEmoji = json['date_emoji'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seva_date'] = date;
    data['tithi_match'] = tithiMatch;
    data['miti'] = miti;
    data['vastra'] = vastra;
    data['mastak'] = mastak;
    data['aabharan'] = aabharan;
    data['special_vastra'] = specialVastra;
    data['special_utsav'] = specialUtsav;
    data['miti_emoji'] = mitiEmoji;
    data['miti_emoji'] = mitiEmoji;
    data['date_emoji'] = dateEmoji;
    return data;
  }
}
