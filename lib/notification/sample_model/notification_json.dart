import '../notification_service.dart';
import 'notification_entity.dart';

class NotificationJson {
  String? title;
  String? description;
  String? image;
  DateTime? createdAt;
  String screen;
  Map<String, dynamic>? screenParams;

  NotificationJson({
    this.screenParams,
    required this.screen,
    this.description,
    this.image,
    this.title,
    this.createdAt,
  });

  factory NotificationJson.fromJson(Map<String, dynamic> json) =>
      NotificationJson(
        title: json["title"],
        screen: NotificationService.getScreenType(json).$1,
        screenParams: NotificationService.getScreenType(json).$2,
        description: json["description"],
        image: json["image"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      );

  NotificationEntity toDomain() => NotificationEntity(
        title: title,
        screen: screen,
        screenParams: screenParams,
        description: description,
        image: image,
        createdAt: createdAt,
      );
}
