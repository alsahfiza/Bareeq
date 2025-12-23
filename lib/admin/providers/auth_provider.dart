import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

// ==================== AUTH PROVIDER ====================
class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  User? _currentUser;
  UserModel? _currentUserData;
  bool _isLoading = false;
  String? _errorMessage;

  // 🔹 ADDED (does not remove anything)
  bool _isInitialized = false;

  // ====================
  // Getters (UNCHANGED)
  // ====================
  User? get currentUser => _currentUser;
  UserModel? get currentUserData => _currentUserData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _currentUser != null;

  bool get isAdmin =>
      _currentUserData?.role == UserRole.admin ||
      _currentUserData?.role == UserRole.superAdmin;

  // 🔹 ADDED (non-breaking)
  bool get isInitialized => _isInitialized;

  // ====================
  // Constructor (UNCHANGED)
  // ====================
  AuthProvider() {
    _initAuth();
  }

  // ====================
  // Initialize authentication listener
  // ====================
  void _initAuth() {
    _firebaseService.auth.authStateChanges().listen((User? user) async {
      _currentUser = user;
      _currentUserData = null;

      if (user != null) {
        try {
          _currentUserData = await _loadUserData(user.uid);
        } catch (e) {
          _errorMessage = 'Failed to load user data: $e';
        }
      }

      _isInitialized = true;
      notifyListeners();
    });
  }

  // ====================
  // Load user data from Firestore
  // ====================
  Future<UserModel?> _loadUserData(String userId) async {
    final doc = await _firebaseService.getDocument(
      collection: 'users',
      docId: userId,
    );

    if (!doc.exists) {
      return null;
    }

    return UserModel.fromFirestore(doc);
  }

  // ====================
  // Sign in
  // ====================
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential =
          await _firebaseService.signInWithEmailPassword(
        email,
        password,
      );

      final userData =
          await _loadUserData(userCredential.user!.uid);

      // 🔧 FIX: admin check AFTER data is loaded
      if (userData == null ||
          (userData.role != UserRole.admin &&
              userData.role != UserRole.superAdmin)) {
        await signOut();
        _errorMessage = 'Access denied. Admin privileges required.';
        return false;
      }

      _currentUser = userCredential.user;
      _currentUserData = userData;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====================
  // Sign up (for creating new admin users)
  // ====================
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential =
          await _firebaseService.signUpWithEmailPassword(
        email,
        password,
      );

      final userData = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        role: UserRole.admin,
      );

      await _firebaseService.createDocument(
        collection: 'users',
        docId: userCredential.user!.uid,
        data: userData.toJson(),
      );

      _currentUser = userCredential.user;
      _currentUserData = userData;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====================
  // Sign out
  // ====================
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firebaseService.signOut();
      _currentUser = null;
      _currentUserData = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to sign out: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====================
  // Reset password
  // ====================
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firebaseService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====================
  // Clear error message
  // ====================
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
