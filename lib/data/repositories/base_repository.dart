import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Base class for all repositories. This class provides a basic
/// infrastructure for dealing with Firebase Authentication and Firestore
/// in a type-safe manner.
///
/// This class provides the following functionality:
/// - `currentUser`: Returns the currently authenticated user.
/// - `uid`: Returns the ID of the currently authenticated user.
/// - `isAuthenticated`: Returns `true` if the user is authenticated,
///   `false` otherwise.
abstract class BaseRepository {
  /// The Firebase Authentication instance.
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// The Firestore instance.
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Database realtime
  final realtimeDb = FirebaseDatabase.instance;

  /// Returns the currently authenticated user.
  User? get currentUser => auth.currentUser;

  /// Returns the ID of the currently authenticated user.
  /// If the user is not authenticated, an empty string is returned.
  String get uid => currentUser?.uid ?? "";

  /// Returns `true` if the user is authenticated, `false` otherwise.
  bool get isAuthenticated => currentUser != null;
}
