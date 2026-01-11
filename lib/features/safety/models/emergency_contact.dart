import 'package:uuid/uuid.dart';

/// Emergency Contact Model
class EmergencyContact {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String relationship;
  final DateTime createdAt;

  EmergencyContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.relationship,
    required this.createdAt,
  });

  factory EmergencyContact.create({
    required String userId,
    required String name,
    required String phone,
    required String relationship,
  }) {
    return EmergencyContact(
      id: const Uuid().v4(),
      userId: userId,
      name: name,
      phone: phone,
      relationship: relationship,
      createdAt: DateTime.now(),
    );
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      relationship: json['relationship'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'relationship': relationship,
      'created_at': createdAt.toIso8601String(),
    };
  }

  EmergencyContact copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? relationship,
    DateTime? createdAt,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
