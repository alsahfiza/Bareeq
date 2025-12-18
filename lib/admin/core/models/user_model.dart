import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // Identity
  String id;
  String fullName;
  String email;
  String phoneNumber;
  String imageUrl;
  // Address (combined + detailed)
  String address;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String postalCode;
  String country;

  // Location
  String latitude;
  String longitude;

  // Role
  bool isAdmin;

  // Meta
  Timestamp createdAt;
  String joinedAt;

  UserModel({
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.imageUrl = '',
    this.address = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
    this.latitude = '',
    this.longitude = '',
    this.isAdmin = false,
    Timestamp? createdAt,
    this.joinedAt = '',
  }) : createdAt = createdAt ?? Timestamp.now();

  /// 🔄 Firestore Document → Model
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel.fromJson(data)..id = doc.id;
  }

  /// 🔄 JSON → Model (used by providers)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      address: json['address'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      isAdmin: json['isAdmin'] ?? false,
      createdAt: json['createdAt'] ?? Timestamp.now(),
      joinedAt: json['joinedAt'] ?? '',
    );
  }

  /// 🧱 Empty placeholder (used in OrdersProvider)
  factory UserModel.loading() {
    return UserModel(fullName: 'Loading...');
  }

  /// 🔼 Model → Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'address': address,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'isAdmin': isAdmin,
      'createdAt': createdAt,
      'joinedAt': joinedAt,
    };
  }
}
