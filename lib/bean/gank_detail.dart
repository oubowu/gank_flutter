
class GankDetail{

  final String id;
  final String createdAt;
  final String desc;
  final String publishedAt;
  final String source;
  final String type;
  final String url;
  final bool used;
  final String who;
  final List<String> images;

  GankDetail({this.id, this.createdAt, this.desc, this.publishedAt, this.source,
      this.type, this.url, this.used, this.who, this.images});

  static fromJson(Map<String,dynamic> json){
    return new GankDetail(
      id: json['_id'],
      createdAt: json['createdAt'],
      desc: json['desc'],
      publishedAt: json['publishedAt'],
      source: json['source'],
      type: json['type'],
      url: json['url'],
      used: json['used'],
      who: json['who'],
      images: json['images'],
    );
  }

  @override
  String toString() {
    return 'GankDetail{id: $id, createdAt: $createdAt, desc: $desc, publishedAt: $publishedAt, source: $source, type: $type, url: $url, used: $used, who: $who, images: $images}';
  }


}