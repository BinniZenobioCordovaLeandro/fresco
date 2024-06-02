import 'dart:convert';

class RequestModel {
  String? id;
  String? title;
  String? description;
  int? latitude;
  int? longitude;
  String? status;
  int? createdAt;
  int? updatedAt;

  RequestModel({
    this.id,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'RequestModel(id: $id, title: $title, description: $description, latitude: $latitude, longitude: $longitude, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory RequestModel.fromMap(Map<String, dynamic> data) => RequestModel(
        id: data['id'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        latitude: data['latitude'] as int?,
        longitude: data['longitude'] as int?,
        status: data['status'] as String?,
        createdAt: data['createdAt'] as int?,
        updatedAt: data['updatedAt'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory RequestModel.fromJson(String data) {
    return RequestModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  RequestModel copyWith({
    String? id,
    String? title,
    String? description,
    int? latitude,
    int? longitude,
    String? status,
    int? createdAt,
    int? updatedAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
