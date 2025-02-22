import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUserData();
  Future<UserModel> SignUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> LogInWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userData = await _firebaseFirestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        return UserModel.fromJson(userData.data()!).copyWith(
          id: currentUser.uid,
          email: currentUser.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> LogInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user == null) {
        throw const ServerException('User is null');
      }
      return UserModel.fromJson({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> SignUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
      });
      if (userCredential.user == null) {
        throw const ServerException('User is null');
      }
      return UserModel.fromJson({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'name': name,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
