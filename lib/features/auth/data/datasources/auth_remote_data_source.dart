import 'package:blog_app/core/error/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> SignUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<String> LogInWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<String> LogInWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement LogInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<String> SignUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential =await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
      'email':email,
      'name':name
    });
      if(userCredential.user ==null ){
        throw const ServerException('User is null');
      }
      return userCredential.user!.uid;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
