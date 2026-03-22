import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firestore_service.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));
final authStateProvider = StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

class AuthService {
  final Ref _ref;
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  AuthService(this._ref);

  Future<UserModel?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    final user = result.user;
    if (user == null) return null;
    final userModel = UserModel(
      id: user.uid, email: user.email ?? '',
      displayName: user.displayName, photoUrl: user.photoURL,
      createdAt: DateTime.now(),
    );
    await _ref.read(firestoreServiceProvider).saveUser(userModel);
    return userModel;
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = result.user;
    if (user == null) return null;
    return _ref.read(firestoreServiceProvider).getUser(user.uid);
  }

  Future<UserModel?> signUpWithEmail(String email, String password, String name) async {
    final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = result.user;
    if (user == null) return null;
    await user.updateDisplayName(name);
    final userModel = UserModel(
      id: user.uid, email: email, displayName: name, createdAt: DateTime.now(),
    );
    await _ref.read(firestoreServiceProvider).saveUser(userModel);
    return userModel;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
