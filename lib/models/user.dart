class AppUser {
  final String uid;
  final String email;
  final String role; // 'admin', 'ngo', 'volunteer'
  final String displayName;
  final int hoursServed;
  final List<String> badges;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.displayName,
    this.hoursServed = 0,
    this.badges = const [],
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'],
      role: data['role'],
      displayName: data['displayName'] ?? '',
      hoursServed: data['hoursServed'] ?? 0,
      badges: List<String>.from(data['badges'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'displayName': displayName,
      'hoursServed': hoursServed,
      'badges': badges,
    };
  }
}