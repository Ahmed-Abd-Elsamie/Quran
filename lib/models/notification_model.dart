class NotificationModel {
  String id;
  String title;
  String body;
  String url;
  String image;

  NotificationModel(this.id, this.title, this.body, this.url, this.image);

  factory NotificationModel.fromJson(dynamic json) {
    return NotificationModel(
        json['id'], json['title'], json['body'], json['url'], json['image']);
  }
}
