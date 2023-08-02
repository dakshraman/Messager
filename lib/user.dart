
class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.id,
    required this.lastActive,
    required this.isOnline,
    required this.pushToken,
    required this.email,
  });
  late final String image;
  late final String about;
  late final String name;
  late final String createdAt;
  late final String id;
  late final String lastActive;
  late final bool isOnline;
  late final String pushToken;
  late final String email;

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      image: json['image'] ?? '',
      about: json['about'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
      lastActive: json['last_active'] ?? '',
      isOnline: json['is_online'] ?? false,
      pushToken: json['push_token'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}
