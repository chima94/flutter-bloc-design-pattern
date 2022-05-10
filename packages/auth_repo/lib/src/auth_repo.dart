import 'package:auth_repo/auth_repo.dart';
import 'package:auth_repo/src/model/auth/auth_error.dart';
import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';





class AuthRepo {

   AuthRepo({
      CacheClient? cache,
     firebase_auth.FirebaseAuth? firebaseAuth,
     FirebaseFirestore? firestore
}):
      _cache = cache ?? CacheClient(),
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final firebase_auth.FirebaseAuth  _firebaseAuth;
  final FirebaseFirestore _firestore;
  final CacheClient _cache;


  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';


  Stream<UserModel> get user{
    return _firebaseAuth.authStateChanges().map((firebaseUser){
      final user = firebaseUser == null ? UserModel.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }




  UserModel get currentUser{
    return _cache.read<UserModel>(key: userCacheKey) ?? UserModel.empty;
  }


  Future<void> signUp({required String email, required String password})async{

    try{

       final cred = await _firebaseAuth
              .createUserWithEmailAndPassword(email: email, password: password);
       await _firestore.doc(email).set(toJson(
         UserModel(id: cred.user!.uid, email: email)
       ));

    }on FirebaseAuthException catch(e){
      throw AuthError.from(e);
    }catch(e){
      throw AuthError.unknown();
    }
  }

  Future<void> login({required String email, required String password})async{
    try{
      await
        _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
    }on FirebaseAuthException catch(e){
      throw AuthError.from(e);
    }
  }

  Future<void> logout() async{
    try{
      await Future.wait([_firebaseAuth.signOut()]);
    }catch(_){
      throw AuthError.unknown();
    }
  }
}


extension on firebase_auth.User{
  UserModel get toUser{
    return UserModel(id: uid, email: email, name: displayName);
  }
}


