import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.fcmToken = const [],
    this.blockedUsers = const [],
  });

  final String uid;
  final String username;
  final String fullName;
  final String email;
  final String phoneNumber;
  final List<String> fcmToken;
  final List<String> blockedUsers;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(
    uid: '',
    username: '',
    fullName: '',
    email: '',
    phoneNumber: '',
    fcmToken: [],
    blockedUsers: [],
  );

  UserModel copyWith({
    String? uid,
    String? username,
    String? fullName,
    String? email,
    String? phoneNumber,
    List<String>? fcmToken,
    List<String>? blockedUsers,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fcmToken: fcmToken ?? this.fcmToken,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      username: data["username"] ?? "",
      fullName: data["fullName"] ?? "",
      email: data["email"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      // fcmToken: data["fcmToken"] ?? <String>[],
      blockedUsers: data["blockedUsers"] ?? <String>[],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'fcmToken': fcmToken,
      'blockedUsers': blockedUsers,
    };
  }
}
