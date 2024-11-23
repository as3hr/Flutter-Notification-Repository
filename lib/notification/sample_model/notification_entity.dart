class NotificationEntity {
  String? title;
  String? description;
  String? image;
  bool isNew;
  DateTime? createdAt;
  String screen;
  Map<String, dynamic>? screenParams;

  NotificationEntity({
    this.description,
    this.image,
    this.screen = "",
    this.screenParams,
    this.isNew = false,
    this.title,
    this.createdAt,
  });
}
