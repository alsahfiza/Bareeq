import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? profileImageUrl;
  final AddressModel? address;
  final LocationModel? location;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final UserRole role;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.phoneNumber,
    this.profileImageUrl,
    this.address,
    this.location,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.role = UserRole.customer,
  });

  // ============================
  // INTERNAL SAFE ROLE PARSER (ADDED – DOES NOT REMOVE ANYTHING)
  // ============================
  static UserRole _safeParseRole(dynamic value) {
    if (value == null) return UserRole.customer;

    final normalized = value.toString().toLowerCase().trim();

    switch (normalized) {
      case 'admin':
        return UserRole.admin;
      case 'superadmin':
      case 'super_admin':
        return UserRole.superAdmin;
      case 'customer':
        return UserRole.customer;
      default:
        return UserRole.customer;
    }
  }

  // ============================
  // ORIGINAL toJson (UNCHANGED STRUCTURE)
  // ============================
  Map<String, dynamic> toJson() {
    return {
      'id': id, // kept (even though redundant)
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'address': address?.toJson(),
      'location': location?.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isActive': isActive,
      'role': role.name,
    };
  }

  // ============================
  // ORIGINAL fromJson (PRESERVED, BUT SAFER)
  // ============================
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(0), // safer fallback
      updatedAt: json['updatedAt'] != null &&
              json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      isActive: json['isActive'] ?? true,
      role: _safeParseRole(json['role']), // 🔧 FIXED (no removal)
    );
  }

  // ============================
  // ORIGINAL fromFirestore (PRESERVED, BUT DEFENSIVE)
  // ============================
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final raw = doc.data();

    if (raw == null) {
      // keeps API intact, avoids crash
      return UserModel(
        id: doc.id,
        email: '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
      );
    }

    final data = raw as Map<String, dynamic>;

    return UserModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }

  // ============================
  // ORIGINAL copyWith (UNCHANGED)
  // ============================
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    AddressModel? address,
    LocationModel? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      address: address ?? this.address,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
    );
  }
}

// ============================
// AddressModel (UNCHANGED)
// ============================
class AddressModel {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? fullAddress;

  AddressModel({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.fullAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'fullAddress': fullAddress,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      fullAddress: json['fullAddress'],
    );
  }
}

// ============================
// LocationModel (UNCHANGED)
// ============================
class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }
}

// ============================
// UserRole enum (UNCHANGED)
// ============================
enum UserRole {
  customer,
  admin,
  superAdmin,
}
