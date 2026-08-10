class Habit {
  final String id;
  final String userId;
  final String name;
  final int streak;
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.streak,
    required this.createdAt,
  });

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      streak: (map['streak'] ?? 0) as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
