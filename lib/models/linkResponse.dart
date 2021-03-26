class LinkResponse {
  final String link;
  final String id;

  LinkResponse({this.link, this.id});

  factory LinkResponse.fromJson(Map<String, dynamic> json) {
    return LinkResponse(link: json['link'], id: json['id']);
  }
}
